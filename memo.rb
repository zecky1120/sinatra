# frozen_string_literal: true

class Memo
  class << self
    def all
      query = 'SELECT * FROM memos ORDER BY id ASC'
      conn.exec(query).to_a
    end

    def find(id)
      query = 'SELECT * FROM memos WHERE id = $1'
      conn.exec(query, [id]).first
    end

    def create(params)
      query = 'INSERT INTO memos(title, content, created_at) VALUES ($1, $2, $3)'
      conn.exec_params(query, params.values_at('title', 'content', 'created_at'))
    end

    def update(params)
      query = 'UPDATE memos SET title = $2, content = $3 WHERE id = $1'
      conn.exec_params(query, params.values_at('id', 'title', 'content'))
    end

    def delete(id)
      query = 'DELETE FROM memos WHERE id = $1'
      conn.exec_params(query, [id])
    end

    private

    def conn
      @conn ||= PG::Connection.new(dbname: 'memo_app')
    end
  end
end
