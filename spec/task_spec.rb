require 'spec_helper'

describe Task do
  it 'is initialized with a name and a task ID' do
    task = Task.new({'name' => 'learn SQL', 'list_id' =>1, 'status' => 'f'})
    task.should be_an_instance_of Task
  end

  it 'tells you its name' do
    task = Task.new({'name' => 'learn SQL', 'list_id' =>1, 'status' => 'f'})
    task.name.should eq 'learn SQL'
  end

  it 'tells you its list ID' do
    task = Task.new({'name' => 'learn SQL', 'list_id' =>1, 'status' => 'f'})
    task.list_id.should eq 1
  end

  it 'starts with no tasks' do
    Task.all.should eq []
  end

  it 'lets you save multiple tasks to the database' do
    task = Task.new({'name' => 'learn SQL', 'list_id' =>1, 'status' => 'f'})
    task.save
    task_two = Task.new({'name' => 'learn math', 'list_id' =>1, 'status' => 'f'})
    task_two.save
    Task.all.should eq [task, task_two]
  end

  it 'lets you remove a task from the database' do
    task = Task.new({'name' => 'teddy bear', 'list_id' =>1, 'status' => 'f'})
    task.save
    task_two = Task.new({'name' => 'air soft gun', 'list_id' =>1, 'status' => 'f'})
    task_two.save
    task.remove
    Task.all.should eq [task_two]
  end

  it 'is the same task if it has the same name and list id' do
    task = Task.new({'name' => 'learn SQL', 'list_id' =>1, 'status' => 'f'})
    task2 = Task.new({'name' => 'learn SQL', 'list_id' =>1, 'status' => 'f'})
    task.should eq task2
  end

  it 'allows you to mark tasks as done' do
    task = Task.new({'name' => 'learn SQL', 'list_id' => 1, 'status' => 'f'})
    task.save
    task.mark_as_done
    Task.all.first.status.should eq 't'
  end

  it 'allows you to enter a date for a task' do
    task = Task.new({'name' => 'learn SQL', 'list_id' => 1, 'status' => 'f'})
    task.save
    task.insert_date('8/8/2014')
    Task.all.first.date.should eq '2014-08-08 12:00:00 -0700'
  end

  it 'allows you to sort tasks in a list by their upcoming due date' do
    list = List.new({'name' => 'Stuff'})
    list.save
    task = Task.new({'name' => 'learn SQL', 'list_id' => list.id, 'status' => 'f'})
    task.save
    task.insert_date('January 2, 2015')
    task2 = Task.new({'name' => 'learn SQL', 'list_id' => list.id, 'status' => 'f'})
    task2.save
    task2.insert_date('December 30, 2013')
    Task.sort_by_date_asc(list.id).should eq [task2, task]
  end

  it 'allows you to sort tasks in a list by their descending due date' do
    list = List.new({'name' => 'Stuff'})
    list.save
    task = Task.new({'name' => 'learn SQL', 'list_id' => list.id, 'status' => 'f'})
    task.save
    task.insert_date('January 2, 2015')
    task2 = Task.new({'name' => 'learn SQL', 'list_id' => list.id, 'status' => 'f'})
    task2.save
    task2.insert_date('December 30, 2013')
    Task.sort_by_date_des(list.id).should eq [task, task2]
  end

  it 'allows you to edit the task name' do
    task = Task.new({'name' => 'learn SQL', 'list_id' => 1, 'status' => 'f'})
    task.save
    task.edit_name('learn Ruby')
    Task.all.first.name.should eq 'learn Ruby'
  end
end
