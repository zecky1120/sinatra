# frozen_string_literal: true

CONN = PG::Connection.new(dbname: 'memo_app')

# Memo class(index, show, create, edit, delete etc.)
class Memo
  class << self

    def all
      query = "SELECT * FROM memos ORDER BY id ASC"
      CONN.exec(query)
    end

    def find(id)
      query = "SELECT * FROM memos WHERE id = $1"
      CONN.exec(query, [id]).first
    end

    def create(params)
      title = params['title']
      content = params['content']
      created_at = Time.now
      params = [title, content, created_at]
      query = "INSERT INTO memos(title, content, created_at) VALUES ($1, $2, $3)"
      CONN.exec_params(query, params)
    end

    def update(id, title, content)
      query = "UPDATE memos SET title = $1, content = $2 WHERE id = $3"
      CONN.exec_params(query, [title, content, id])
    end

    def delete(id)
      query = "DELETE FROM memos WHERE id = $1"
      CONN.exec_params(query, [id])
    end
  end
end
