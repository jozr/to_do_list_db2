require 'spec_helper'

describe List do
  it 'is initialized with a name' do
    list = List.new({'name' => 'Epicodus stuff'})
    list.should be_an_instance_of List
  end

  it 'tells you its name' do
    list = List.new({'name' => 'Stuff'})
    list.name.should eq 'Stuff'
  end

  it 'is the same list if it has the same name' do
    list1 = List.new({'name' => 'Stuff'})
    list2 = List.new({'name' => 'Stuff'})
    list1.should eq list2
  end

  it 'starts off with no lists' do
    List.all.should eq []
  end

  it 'lets you save multiple lists to the database' do
    list = List.new({'name' => 'Epicodus stuff'})
    list.save
    list_two = List.new({'name' => 'Yeah'})
    list_two.save
    List.all.should eq [list, list_two]
  end

  it 'lets you remove a lists from the database' do
    list = List.new({'name' => 'Stuff'})
    list.save
    list_two = List.new({'name' => 'More stuff'})
    list_two.save
    list.remove
    List.all.should eq [list_two]
  end

  it 'sets its ID when you save it' do
    list = List.new({'name' => 'So much stuff'})
    list.save
    list.id.should be_an_instance_of Fixnum
  end

  it 'allows you to view all tasks from a specific list' do
    list = List.new({'name' => 'Stuff'})
    list.save
    task1 = Task.new({'name' => 'computer', 'list_id' => list.id, 'status' => 'f'})
    task1.save
    task2 = Task.new({'name' => 'backpack', 'list_id' => 2, 'status' => 'f'})
    task2.save
    list.return_tasks.should eq ['computer']
  end
end
