# a simple/configurable rake task that generates some random fake data for the app (using faker) at various sizes
# NOTE: requires the faker or ffaker gem 
#   sudo gem install faker - http://faker.rubyforge.org
#   OR
#   sudo gem install ffaker - http://github.com/EmmanuelOga/ffaker

require 'faker'

class Fakeout
  RAILS_ENV = 'development'

  # START Customizing

  # 1. first these are the model names we're going to fake out, note in this example, we don't create tags/taggings specifically
  # but they are defined here so they get wiped on the clean operation
  # e.g. this example fakes out, Users, Questions and Answers, and in doing so fakes some Tags/Taggings
  MODELS = %w(Client ServiceJob)

  # 2. now define a build method for each model, returning a list of attributes for Model.create! calls
  # check out the very excellent faker gem rdoc for faking out anything from emails, to full addresses; http://faker.rubyforge.org/rdoc
  # NOTE: a build_??? method MUST exist for each model you specify above
  def build_client
    { 
      name: Faker::Name.name,
      phone_number: Faker::PhoneNumber.phone_number.gsub(/\D/,'')[0..10]
    }
  end
  
  def build_device
    device_time = fake_time_from 1.year.ago
    {
      created_at: device_time,
      updated_at: device_time,
      client: pick_random(Client),
      device_type: pick_random(DeviceType),
      serial_number: rand(100).to_s+random_letters+rand(1000).to_s+random_letters+rand(10000).to_s,
      comment: Faker::Lorem.sentence(1+rand(5)).chop,
      done_at: nil
      #device_tasks_attributes: {
      #  task: pick_random(Task),
      #  cost: rand(5)*1000,
      # comment: Faker::Lorem.paragraph(1).chop
      #}
    }
  end

  def build_infos
    info_time = fake_time_from 1.year.ago
    {
      created_at: info_time,
      updated_at: info_time,
      title: Faker::Lorem.sentence(1+rand(5)).chop,
      content: "<p>#{Faker::Lorem.paragraph(1).chop}</p>"
    }
  end

  # in this example i'm faking out time - like Marty McFly!
  # def build_question
    # question_time = fake_time_from(1.year.ago)
# 
    # { :title            => "#{Faker::Lorem.sentence(8+rand(8)).chop}?",
      # :information      => Faker::Lorem.paragraph(rand(3)),
      # :tag_list         => random_tag_list(all_tags),
      # :notify_user      => false,
      # :created_at       => question_time,
      # :updated_at       => question_time,
      # :spam_answer      => '2',
      # :spam_question    => '1+1 is?',
      # :possible_answers => [Digest::MD5.hexdigest('2')],
      # :user             => pick_random(User, true) }
  # end

  # in this example i'm faking out time again! - this time to be after the question's created at time
  # def build_answer
    # question    = pick_random(Question)
    # answer_time = question.created_at+rand(168).hours
# 
    # { :title            => Faker::Lorem.paragraph(1+rand(4)),
      # :question         => question,
      # :created_at       => answer_time,
      # :updated_at       => answer_time,
      # :user             => pick_random(User, true),
      # :spam_answer      => '2',
      # :spam_question    => '1+1 is?',
      # :possible_answers => [Digest::MD5.hexdigest('2')],
    # }
  # end

  # return nil, or an empty hash for models you don't want to be faked out on create, but DO want to be clearer away
  # def build_tag; end

  # def build_tagging; end
  
  # called after faking out, use this method for additional updates or additions
  def post_fake
    ServiceJob.find_each do |service_job|
      (rand(9)+1).times do
        service_job.device_tasks.create(task: pick_random(Task), cost: rand(5)*1000, done: false,
            comment: Faker::Lorem.paragraph(1).chop)
      end
    end
      
    # User.create!(build_user('matt', 'matt@hiddenloop.com', 'password'))
    # User.update_all('email_confirmed = true')
  end

  # 3. optionally you can change these numbers, basically they are used to determine the number of models to create
  # and also the size of the tags array to choose from.  To check things work quickly use the tiny size (1 for everything)
  def tiny
    1
  end
  
  def small
    25+rand(50)
  end

  def medium
    250+rand(250)
  end

  def large
    1000+rand(500)
  end

  # END Customizing

  attr_accessor :all_tags, :size

  def initialize(size, prompt=true)
    self.size     = size
    self.all_tags = Faker::Lorem.words(send(size))
  end

  def fakeout
    puts "Faking it ... (#{size})"
    Fakeout.disable_mailers
    MODELS.each do |model|
      if !respond_to?("build_#{model.underscore}")
        puts "  * #{model.pluralize}: **warning** I couldn't find a build_#{model.underscore} method"
        next
      end
      1.upto(send(size)) do
        attributes = send("build_#{model.underscore}")
        model.constantize.create!(attributes) if attributes && !attributes.empty?
      end
      puts "  * #{model.pluralize}: #{model.constantize.count(:all)}"
    end
    post_fake
    puts "Done, I Faked it!"
  end

  def fake_infos
    if respond_to? "build_infos"
      1.upto 50 do
        attributes = build_infos #send "build_infos"
        Info.create! attributes if attributes and attributes.present?
      end
      puts "Done, I Faked it!"
    end
  end
  
  def self.prompt
    puts "Really? This will clean all #{MODELS.map(&:pluralize).join(', ')} from your #{RAILS_ENV} database y/n? "
    STDOUT.flush
    (STDIN.gets =~ /^y|^Y/) ? true : exit(0)
  end

  def self.clean(prompt = true)
    self.prompt if prompt
    puts "Cleaning all ..."
    Fakeout.disable_mailers
    MODELS.each do |model|
      model.constantize.delete_all
    end
  end

  # by default, all mailings are disabled on faking out
  def self.disable_mailers
    ActionMailer::Base.perform_deliveries = false
  end
  
  
  private
  # pick a random model from the db, done this way to avoid differences in mySQL rand() and postgres random()
  def pick_random(model, optional = false)
    return nil if optional && (rand(2) > 0)
    ids = ActiveRecord::Base.connection.select_all("SELECT id FROM #{model.to_s.tableize}")
    model.find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end

  # useful for prepending to a string for getting a more unique string
  def random_letters(length = 2)
    Array.new(length) { (rand(122-97) + 97).chr }.join
  end

  # pick a random number of tags up to max_tags, from an array of words, join the result with seperator
  def random_tag_list(tags, max_tags = 5, seperator = ',')
    start = rand(tags.length)
    return '' if start < 1
    tags[start..(start+rand(max_tags))].join(seperator)
  end

  # fake a time from: time ago + 1-8770 (a year) hours after
  def fake_time_from(time_ago = 1.year.ago)
    time_ago+(rand(8770)).hours
  end
end


# the tasks, hook to class above - use like so;
# rake fakeout:clean
# rake fakeout:small[noprompt] - no confirm prompt asked, useful for heroku or non-interactive use
# rake fakeout:medium RAILS_ENV=bananas
#.. etc.
namespace :fakeout do

  desc "clean away all data"
  task :clean, [:no_prompt] => :environment do |t, args|
    Fakeout.clean(args.no_prompt.nil?)
  end
  
  desc "fake out a tiny dataset"
  task :tiny, [:no_prompt] => :clean do |t, args|
    Fakeout.new(:tiny).fakeout
  end

  desc "fake out a small dataset"
  task :small, [:no_prompt] => :clean do |t, args|
    Fakeout.new(:small).fakeout
  end

  desc "fake out a medium dataset"
  task :medium, [:no_prompt] => :clean do |t, args|
    Fakeout.new(:medium).fakeout
  end

  desc "fake out a large dataset"
  task :large, [:no_prompt] => :clean do |t, args|
    Fakeout.new(:large).fakeout
  end

  desc "fake out INFOS"
  task :infos do |t, args|
    Fakeout.new(:small).fake_infos
  end

end