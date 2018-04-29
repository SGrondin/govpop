RSpec::Matchers.define :match_schema do |schema|
  match do |response|
    schema_path = "#{Dir.pwd}/spec/support/schemas/#{schema}.json"
    JSON::Validator.validate!(schema_path, response.body, strict: true)
  rescue JSON::Schema::ValidationError => e
    e.message = "#{e.message} --- #{response.body}"
    raise
  end
end

RSpec::Matchers.define :have_status do |status|
  match do |response|
    expect(response).to match_schema "status"

    if response.status != status
      raise ValidationError.new("expected #{status}, got #{response.status} --- #{response.body}")
    end
    true
  end
end

RSpec::Matchers.define :have_error do |error|
  match do |response|
    parsed = JSON.parse(response.body)
    if parsed['error'] != error
      raise ValidationError.new("expected '#{error}', got '#{parsed['error']}' --- #{response.body}")
    end
    true
  end
end

RSpec::Matchers.define :be_a_boolean do
  match do |actual|
    expect(actual).to be_in([true, false])
  end
end

RSpec::Matchers.define :be_a_nullable_string do
  match do |actual|
    unless actual.nil?
      return expect(actual).to be_a(String)
    end
    true
  end
end

RSpec::Matchers.define :be_a_timewithzone do
  match do |actual|
    expect(actual).to be_a(ActiveSupport::TimeWithZone)
  end
end

RSpec::Matchers.define :be_a_nullable_timewithzone do
  match do |actual|
    unless actual.nil?
      return expect(actual).to be_a(ActiveSupport::TimeWithZone)
    end
    true
  end
end

RSpec::Matchers.define :be_a_bigdecimal do
  match do |actual|
    expect(actual).to be_a(BigDecimal)
  end
end

RSpec::Matchers.define :be_a_nullable_bigdecimal do
  match do |actual|
    unless actual.nil?
      return expect(actual).to be_a(BigDecimal)
    end
    true
  end
end
