class ExercisesController < ApplicationController
    get "/exercises" do
      Exercise.all.to_json(include: [workout: {only: [:id, :title]}], except: [:created_at, :updated_at])
    end
  
    get "/workouts/:workout_id/exercises" do
      find_workout
      @workout.exercises.to_json(include: [:workout])
    end
  
    get "/exercises/:id" do
      find_exercise
      exercise_to_json
    end
  
    post "/workouts/:workout_id/exercises" do
      find_workout
      @exercise = @workout.exercises.build(params)
      if @exercise.save
        exercise_to_json
      else
        { errors: ["Exercise Is Taken"] }.to_json
      end
    end
  
    patch "/exercises/:id" do
      find_exercise
      if @exercise.update(params)
        exercise_to_json
      else
        { errors: ["Exercise Does Not Exist"] }.to_json
      end
    end
  
    delete "/exercises/:id" do
      find_exercise
      if @exercise
        @exercise.destroy
        @exercise.to_json
      else
        { errors: ["Exercise Does Not Exist"] }.to_json
      end
    end
  
    private
      def find_exercise
        @exercise = Exercise.find_by_id(params["id"])
      end
  
      def find_workout
        @author = Workout.find_by_id(params["workout_id"])
      end
  
      def exercise_to_json
        @exercise.to_json(include: [:workout])
      end
  
      def exercise_error_messages
        { errors: @exercise.errors.full_messages }.to_json
      end
  end