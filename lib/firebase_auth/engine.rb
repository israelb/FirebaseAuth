module FirebaseAuth
  class Engine < ::Rails::Engine
    isolate_namespace FirebaseAuth

    config.autoload_paths += %W(#{config.root}/app/services)

    initializer "firebase_auth.importmap", before: "importmap" do |app|
      # NOTE: this will add pins from this engine to the main app
      # https://github.com/rails/importmap-rails#composing-import-maps
      app.config.importmap.paths << root.join("config/importmap.rb")

      # NOTE: something about cache; I did not look into it.
      # https://github.com/rails/importmap-rails#sweeping-the-cache-in-development-and-test
      app.config.importmap.cache_sweepers << root.join("app/assets/javascripts")
    end

    # NOTE: add engine manifest to precompile assets in production
    initializer "firebase_auth.assets.precompile" do |app|
      app.config.assets.precompile += %w( firebase_auth/application.js firebase_auth/application.css )
    end

    # initializer :append_migrations do |app|
    #   unless app.root.to_s.match(root.to_s)
    #     puts "Appending migration paths from FirebaseAuth to #{app.root}"
    #     config.paths["db/migrate"].expanded.each do |expanded_path|
    #       puts "Appending migration path: #{expanded_path}"
    #       app.config.paths["db/migrate"] << expanded_path
    #     end
    #   end
    # end
  end
end
