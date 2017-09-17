namespace :admin do
  desc 'Add admin user'
  task :add, ['email', 'password'] => :environment do |task, args|
    user = User.new(
      email: args[:email],
      password: args[:password]
    )

    if user.save
      puts "Congrats! #{user.email} is now an admin."
    else
      puts "Failed to create admin #{user.email}"
    end
  end
end
