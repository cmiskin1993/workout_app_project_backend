class AddExerciseIdToWorkouts < ActiveRecord::Migration[6.1]
  def change
    add_column :exercises, :workout_id, :integer, null: false
  end
end
