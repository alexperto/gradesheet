class CreateSupportingSkillEvaluations < ActiveRecord::Migration
  def self.up
    create_table :supporting_skill_evaluations do |t|
      t.integer :student_id
      t.integer :course_term_skill_id
      t.string  :score

      t.timestamps
    end
  end

  def self.down
    drop_table :supporting_skill_evaluations
  end
end
