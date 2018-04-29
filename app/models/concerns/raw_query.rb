class RawQuery

  def self.make_placeholders nb
    Array.new(nb) {'?'}.join(', ')
  end

  def initialize query, arguments=[]
    @parameters = [query] + arguments
    @executed = false
    @raw_result = nil
  end

  def get_raw_rows
    if not @executed
      query = @parameters.size == 1 ? @parameters.first : ActiveRecord::Base.send(:sanitize_sql_array, @parameters)
      @raw_result = ActiveRecord::Base.connection.execute(query)
      @executed = true
    end
    @raw_result
  end

  def run_ignore_result
    get_raw_rows
    nil
  end

  def get_single_column
    get_raw_rows.map { |row| row.values.first }
  end

  def get_single_cell
    first_row = get_raw_rows.first
    if first_row.nil? then nil else first_row.values.first end
  end

  def get_single_json
    first_row = get_raw_rows.first
    if first_row.nil? || first_row.values.first.nil? then nil else JSON.parse(first_row.values.first) end
  end

  def self.parse_time s
    s.nil? ? nil : Time.zone.parse(s)
  end

  def self.parse_bigdecimal s
    s.nil? ? nil : BigDecimal.new(s)
  end

end
