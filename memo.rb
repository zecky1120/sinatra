# frozen_string_literal: true

CONN = PG::Connection.new(dbname: 'memo_app')

# Memo class(index, show, create, edit, delete etc.)
class Memo
  class << self
    def build_id
      SecureRandom.hex
    end

    def all
      query = "SELECT * FROM memos"
      memos = CONN.exec(query)
      memos.sort_by { |memo| memo['created_at'] }
    end

    def find(id)
      all.find { |memo| memo['id'] == id }
    end

    def create(id, title, content, created_at)
      query = "INSERT INTO memos(id, title, content, created_at) VALUES ($1, $2, $3, $4);"
      CONN.exec_params(query, [id, title, content, created_at])
    end

    def update(id, title, content)
      query = "UPDATE memos SET title = $1, content = $2 WHERE id = $3;"
      CONN.exec_params(query, [title, content, id])
    end

    def delete(id)
      query = "DELETE FROM memos WHERE id = $1;"
      CONN.exec_params(query, [id])
    end
  end
end
