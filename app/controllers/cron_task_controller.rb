class CronTaskController < ApplicationController
    def index
        @server = Sidekiq::server?
        @tasks = Sidekiq::Cron::Job.all
    end

    def toggle
        job = Sidekiq::Cron::Job.find :name => params[:name]
        if job.status == 'enabled' then
          job.disable!
        else
          job.enable!
        end
        redirect_to action: "index"
    end

    def enqueue
        job = Sidekiq::Cron::Job.find :name => params[:name]
        job.enque!
        redirect_to action: "index"
    end

end
