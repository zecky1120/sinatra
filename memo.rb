# frozen_string_literal: true

CONN = PG::Connection.new(dbname: 'memo_app')

# Memo class(index, show, create, edit, delete etc.)
class Memo
  class << self
    def all
      query = 'SELECT * FROM memos ORDER BY id ASC'
      CONN.exec(query).to_a
    end

    def find(id)
      query = 'SELECT * FROM memos WHERE id = $1'
      CONN.exec(query, [id]).first
    end

    def create(params)
      query = 'INSERT INTO memos(title, content, created_at) VALUES ($1, $2, $3)'
      CONN.exec_params(query, params.values_at('title', 'content', 'created_at'))
    end

    def update(params)
      query = 'UPDATE memos SET title = $2, content = $3 WHERE id = $1'
      CONN.exec_params(query, params)
    end

    def delete(id)
      query = 'DELETE FROM memos WHERE id = $1'
      CONN.exec_params(query, [id])
    end
  end
end
