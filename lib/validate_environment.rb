unless ENV["SKIP_VALIDATION"] == "true"
  if !ENV["DATABASE_URL"] && !Rails.env.test?
    raise "Datable url missing. Please set DATABASE_URL."
  end

  if !ENV["TEST_DATABASE_URL"] && Rails.env.test?
    raise "Test database url missing. Please set TEST_DATABASE_URL."
  end

  if !ENV["SECRET_KEY_BASE"] && Rails.env.production?
    raise "Secret key base missing. Please set SECRET_KEY_BASE."
  end
end