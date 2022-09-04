class WorkoutsController < ApplicationController
    get "/workouts" do
        Workout.all.to_json(include: [exercises: {only: [:id, :name, :amount]}], except: [:created_at, :updated_at])
    end
  
    get "/workouts/:id" do
      find_workout
      workout_to_json
    end
  
    post "/workouts" do
      @workout = Workout.new(params)
      if @workout.save
        workout_to_json
      else
        { errors: ["Workout Is Taken"] }.to_json
      end
    end
  
    patch "/workouts/:id" do
      find_workout
      if @workout.update(params)
        workout_to_json
      else
        { errors: ["Workout Does Not Exist"] }.to_json
      end
    end
  
    delete "/workouts/:id" do
      find_workout
      if @workout
        @workout.destroy
        @workout.to_json
      else
        { errors: ["Workout Does Not Exist"] }.to_json
      end
    end
  
    private
      def find_workout
        @workout = Workout.find_by_id(params["id"])
      end
  
      def workout_to_json
        @workout.to_json(include: [:exercises])
      end
  
      def workout_error_messages
        { errors: @workout.errors.full_messages }.to_json
      end
  end
