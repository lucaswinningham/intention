task default: :spec

libs = %w[core access ingestion validation].map { |lib| "intention-#{lib}" }

desc "Run specs for #{libs.join(', ')}"
task :spec do
  libs.each do |lib|
    FileUtils.cd(File.expand_path(lib, __dir__))

    system('rspec', out: $stdout, err: :out)
  end
end
