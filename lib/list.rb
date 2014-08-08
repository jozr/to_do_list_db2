class List

  attr_reader :name, :id

  def initialize(hash)
    @name = hash['name']
    @id = hash['id']
  end

  def ==(another_name)
    self.name == another_name.name
  end

  def self.all
    results = DB.exec('SELECT * FROM lists;')
    lists = []
    results.each do |result|
      name = result['name']
      id = result['id'].to_i
      lists << List.new({'name' => name, 'id' => id})
    end
  lists
  end

  def save
    results = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def remove
    DB.exec("DELETE FROM lists WHERE id = #{@id}")
    DB.exec("DELETE FROM tasks WHERE list_id = #{@id}")
  end

  def return_tasks
    result = DB.exec("SELECT * FROM tasks WHERE list_id = #{@id}")
    tasks = []
    result.each do |result|
      name = result['name']
      tasks << name
    end
    tasks
  end

end
