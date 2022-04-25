require_relative "../config/environment.rb"

class Student

  attr_reader :id 
  attr_accessor :name, :grade 

  def initialize(id = nil, name, grade)
    @id = id 
    @name = name 
    @grade = grade 
  end

  def save

    if @id 
      self.update 
    else 
      
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?);
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]
    
    end 

  end
  
  def self.create(name, grade) 
    
    student = self.new(name, grade)
    
    student.save

  end 

  def self.create_table

    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    );
    SQL

    DB[:conn].execute(sql)

  end 
 
  def self.drop_table

    sql = <<-SQL
    DROP TABLE students;
    SQL

    DB[:conn].execute(sql)

  end

  def self.find_by_name(name)

    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name == ?;
    SQL

    db_record = DB[:conn].execute(sql, name)[0]

    self.new_from_db(db_record)

  end 
  
  def self.new_from_db(array)
    Student.new(array[0], array[1], array[2])
  end 

  def update

    sql = <<-SQL
    UPDATE students
    SET name = ?, grade = ?
    WHERE id == ?;
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)

  end 

end
