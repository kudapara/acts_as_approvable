class ActsAsApprovableGenerator < Rails::Generator::Base
  default_options :base => 'ApplicationController'

  def manifest
    record do |m|
      m.migration_template 'create_approvals.rb', 'db/migrate', :migration_file_name => 'create_approvals'

      m.directory 'app/controllers'
      m.template 'approvals_controller.rb', 'app/controllers/approvals_controller.rb'

      m.directory 'app/views/approvals'
      m.template "index.html.#{view_language}", "app/views/approvals/index.html.#{view_language}"

      m.route 'map.resources :approvals, :only => [:index], :collection => [:history], :member => [:approve, :reject]'
    end
  end

  protected
  def view_language
    options[:haml] ? 'haml' : 'erb'
  end

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on('--haml', 'Generate HAML views instead of ERB.') { |v| options[:haml] = v }
  end
end

# Gross! But Rails 2 only allows us to define resources with no options.
module Rails
  module Generator
    module Commands
      class Create
        def route(route)
          sentinel = 'ActionController::Routing::Routes.draw do |map|'

          logger.route route
          unless options[:pretend]
            gsub_file 'config/routes.rb', /#{Regexp.escape(sentinel)}/mi do |match|
              "#{match}\n  #{route}\n"
            end
          end
        end
      end

      class Destroy
        def route(route)
          look_for = "\n  #{Regexp.escape(route)}\n"
          logger.route route
          gsub_file 'config/routes.rb', /#{look_for}/mi, ''
        end
      end
    end
  end
end
