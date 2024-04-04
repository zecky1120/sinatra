# frozen_string_literal: true

class Memo
  def initialize
    @conn = PG::Connection.new(dbname: 'memos')
  end
end
