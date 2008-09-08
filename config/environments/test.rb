Merb.logger.info("Loaded TEST Environment...")
Merb::Config.use { |c|
  c[:testing] = true
  c[:exception_details] = true
  c[:log_auto_flush ] = true
}

Merb::BootLoader.before_app_loads do
  DataMapper.setup(:default, "sqlite3::memory:")
end