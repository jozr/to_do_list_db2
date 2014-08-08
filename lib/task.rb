require 'pg'
require 'chronic'

class Task
  attr_reader :name, :list_id, :status, :date

  def initialize(hash)
    @name = hash['name']
    @list_id = hash['list_id']
    @status = hash['status']
    @date = hash['date']
  end

  def save
    DB.exec("INSERT INTO tasks (name, list_id, status) VALUES ('#{@name}', #{@list_id}, '#{@status}');")
  end

  def remove
    DB.exec("DELETE FROM tasks WHERE name = '#{@name}';")
  end

  def mark_as_done
    DB.exec("UPDATE tasks SET status = 't' WHERE name = '#{@name}';")
    @status = 't'
  end

  def insert_date(user_date)
    chroniced = Chronic.parse(user_date)
    DB.exec("UPDATE tasks SET date = '#{chroniced}' WHERE name = '#{@name}';")
    @date = user_date
  end

  def self.sort_by_date_asc(list)
    results = DB.exec("SELECT * FROM tasks WHERE list_id = #{list};")
    tasks = []
    results.each do |result|
      name = result['name']
      list_id = result['list_id'].to_i
      date = result['date']
      status = result['status']
      tasks << Task.new({'date' => date, 'name' => name, 'list_id' => list_id, 'status' => status})
    end
    tasks.sort_by {|object| object.date}
  end

  def edit_name(edited_name)
    DB.exec("UPDATE tasks SET name = '#{edited_name}' WHERE name = '#{@name}';")
    @name = edited_name
  end

  def self.sort_by_date_des(list)
    results = DB.exec("SELECT * FROM tasks WHERE list_id = #{list};")
    tasks = []
    results.each do |result|
      name = result['name']
      list_id = result['list_id'].to_i
      date = result['date']
      status = result['status']
      tasks << Task.new({'date' => date, 'name' => name, 'list_id' => list_id, 'status' => status})
    end
    reversed = tasks.sort_by {|object| object.date}
    reversed.reverse
  end

  def self.all
    results = DB.exec("SELECT * FROM tasks;")
    tasks = []
    results.each do |result|
      name = result['name']
      list_id = result['list_id'].to_i
      status = result['status']
      date = result['date']
      tasks << Task.new({'name' => name , 'list_id' => list_id, 'status' => status, 'date' => date})
    end
    tasks
  end

  def ==(another_name)
    self.name == another_name.name && self.list_id == another_name.list_id && self.status == another_name.status
  end
end
