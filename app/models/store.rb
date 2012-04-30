class Store < ActiveRecord::Base
  # Callbacks
  before_save :reformat_phone
  before_save :find_store_coordinates
  before_destroy :make_inactive
  
  # Relationships
  has_many :assignments
  has_many :employees, :through => :assignments
  has_many :shifts, :through => :assignments
  
  
  # Validations
  # make sure required fields are present
  validates_presence_of :name, :street, :city
  # if state is given, must be one of the choices given (no hacking this field)
  validates_inclusion_of :state, :in => %w[PA OH WV], :message => "is not an option"
  # if zip included, it must be 5 digits only
  validates_format_of :zip, :with => /^\d{5}$/, :message => "should be five digits long"
  # phone can have dashes, spaces, dots and parens, but must be 10 digits
  validates_format_of :phone, :with => /^\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}$/, :message => "should be 10 digits (area code needed) and delimited with dashes only"
  # make sure stores have unique names
  validates_uniqueness_of :name
  
  # Scopes
  scope :alphabetical, order('name')
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  
  
  # Misc Constants
  STATES_LIST = [['Ohio', 'OH'],['Pennsylvania', 'PA'],['West Virginia', 'WV']]

  def create_map_link (zoom=13, width=800, height=800)
    markers = ""; i = 1
      markers += "&markers=color:red%7Ccolor:red%7Clabel:#{i}%7C#{self.latitude},#{self.longitude}"
      i+=1
    map = "http://maps.google.com/maps/api/staticmap?center=#{self.latitude}, #{self.longitude}&zoom=#{zoom}&size=#{width}x#{height}&maptype=roadmap#{markers}&sensor=false"
  end

  def self.create_map_of_all_stores_link(zoom=13, width=800, height=800)
    markers = ""; i = 1
    store_coords = Array.new
    Store.active.alphabetical.each do |store|
      markers += "&markers=color:red%7Ccolor:red%7Clabel:#{i}%7C#{store.latitude},#{store.longitude}"
      i+=1
      store_coords << store.to_coordinates
    end
    center = store_coords.transpose.map{|c| c.inject{|a, b| a + b}.to_f / c.size}
    map = "htp://maps.google.com/maps/api/staticmap?center=#{center},#{center}&zoom=#{zoom}&size=#{width}x#{height}&maptype=roadmap#{markers}&sensor=false"
  end

  def to_coordinates
    coord = Array.new
    coord << self.latitude
    coord << self.longitude
    coord
  end

  def get_shift_hours_for_past_days(num=14)
    sum=0
    self.shifts.for_past_days(num).each do |shift|
      sum += shift.time_worked_in_minutes
    end
    return sum/60
  end

  def get_unworked_hours_for_week
    unworked_week = Array.new (8) {Array.new (24)}
    uncoming_shifts = Shift.for_store(self.id).for_next_days(7)
    for i in 0..7
      for j in 0..23
        unworked_week[i][j] = 0
      end
    end

    (0..7).each do |i|
      upcoming_shifts.each do |shift|
        curr_day = i.days.from_now.to_date
        if curr_day.month == shift.date.month && curr_day.day == shift.date.day
          for j in shift.start_time.localtime.hour..shift.end_time.localtime.hour
            unworked_week[i][j] = 1
          end
        end
      end
    end
    unworked_week
  end
  
  
  # Callback code
  # -----------------------------
  private
  # We need to strip non-digits before saving to db
  def reformat_phone
    phone = self.phone.to_s  # change to string in case input as all numbers 
    phone.gsub!(/[^0-9]/,"") # strip all non-digits
    self.phone = phone       # reset self.phone to new string
  end

  def make_inactive
    update_attribute(:active, false) and return false
  end

  def find_store_coordinates
    coord = Geokit::Geocoders::GoogleGeocoder.geocode "#{street} #{city}, #{state} #{zip}"
    if coord.success
      self.latitude, self.longitude = coord.11.split(',')
    else
      errors.add_to_base("Error with geocoding")
    end
  end
end
