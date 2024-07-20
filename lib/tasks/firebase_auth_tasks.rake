# desc "Explaining what the task does"
# task :firebase_auth do
#   # Task goes here
# end

# namespace :firebase_auth do
#   namespace :install do
#     desc "Copy migrations from FirebaseAuth engine to application"
#     task migrations: :environment do
#       source = File.expand_path("../../../db/migrate", __FILE__)
#       destination = File.join(Rails.root, "db", "migrate")
#       puts "Copying migrations from #{source} to #{destination}"
#       FileUtils.cp_r(Dir["#{source}/*"], destination)
#       puts "Copied FirebaseAuth migrations to #{destination}"
#     end
#   end
# end

# namespace :firebase_auth do
#   namespace :install do
#     desc "Run the FirebaseAuth install generator"
#     task migrations: :environment do
#       Rails::Generators.invoke('firebase_auth:install')
#     end
#   end
# end
