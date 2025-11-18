require 'dotenv/tasks'
require 'tempfile'


task :default => :all


task :all => :build do
end


task build: :dotenv do
  export_presets_path = 'export_presets.cfg'
  begin
    backup = Tempfile.new('export_presets.cfg', 'tmp')
    cp export_presets_path, backup.path
    result = backup.read \
      .gsub('$APPLE_TEAM_ID',     ENV['APPLE_TEAM_ID'])
      .gsub('$CODESIGN_IDENTITY', ENV['CODESIGN_IDENTITY'])

    File.write(export_presets_path, result)
    sh 'godot --headless --export-release "macOS"'
  ensure
    mv backup.path, export_presets_path
  end
end
