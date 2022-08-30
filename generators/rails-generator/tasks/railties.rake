stdlib_dependencies = %w[benchmark date digest json logger monitor mutex_m pathname singleton time minitest securerandom ipaddr did_you_mean forwardable openssl socket]
gem_dependencies = %w[nokogiri i18n rack rails-dom-testing]
rails_dependencies = %w[actionpack actionview activejob activemodel activerecord activestorage activesupport]

VERSIONS.each do |version|
  namespace version do
    namespace :railties do
      export = "export/railties/#{version}"

      desc "export to #{export}"
      task :export do
        sh "rm -fr #{export}"
        sh "mkdir -p #{export}"

        if File.exist?("out/#{version}/active_record/destroy_association_async_job.rbs")
          sh "mkdir -p #{export}/active_record"
          sh "cp out/#{version}/active_record/destroy_association_async_job.rbs #{export}/active_record/destroy_association_async_job.rbs"
        end
      end

      desc "validate version=#{version} gem=railties"
      task :validate do
        validate(
          export: export,
          version: version,
          stdlib_dependencies: stdlib_dependencies,
          gem_dependencies: gem_dependencies,
          rails_dependencies: rails_dependencies,
        )
      end

      desc "install to ../../../gems/railties/#{version}"
      task :install do
        install_to = File.expand_path("../../../gems/railties/#{version}", __dir__)
        sh "rm -fr #{install_to}"
        sh "cp -a #{export} #{install_to}"
      end
    end
  end
end
