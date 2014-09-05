namespace :nakanohito do
  desc "Register social post schedules from config"
  task :register do
    Nakanohito.register!
  end
end
