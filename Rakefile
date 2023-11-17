task default: :spec

libs = %w[support core access ingestion validation].map { |lib| "intention-#{lib}" }
desc "Run specs for #{libs.join(', ')}"
task :spec do
  libs.each do |lib|
    FileUtils.cd(File.expand_path(lib, __dir__))

    system('rspec', out: $stdout, err: :out)
  end
end

desc 'Open an interactive console with `intention-metagem`'
task :console do
  FileUtils.cd('intention-metagem')

  system('./bin/console', out: $stdout, err: :out)
end
