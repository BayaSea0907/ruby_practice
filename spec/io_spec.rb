# frozen_string_literal: true

require 'csv'

RSpec.describe IO do
  let!(:csv_io) do
    csv_string = <<~CSV
      col1,col2,col3
      1,2,3
      4,5,6
      7,8,9
    CSV
    CSV.new(csv_string, headers: true).to_io
  end

  describe '#each' do
    it '引数無しなら1行ずつ読み込んで、読み込んだ文字列を引数にしてブロックを実行する' do
      results = []
      csv_io.each do |line|
        results << line
      end

      expect(results).to eq ["col1,col2,col3\n", "1,2,3\n", "4,5,6\n", "7,8,9\n"]
    end
  end

  describe '#gets, #lineno' do
    it '#getsは1行ずつ読み込み、EOFに到達した時はnilを返す。#linenoは現在の行番号を返す' do
      expect(csv_io.lineno).to eq 0
      expect(csv_io.gets).to eq "col1,col2,col3\n"

      expect(csv_io.lineno).to eq 1
      expect(csv_io.gets).to eq "1,2,3\n"

      expect(csv_io.lineno).to eq 2
      expect(csv_io.gets).to eq "4,5,6\n"

      expect(csv_io.lineno).to eq 3
      expect(csv_io.gets).to eq "7,8,9\n"

      expect(csv_io.lineno).to eq 4
      expect(csv_io.gets).to eq nil

      # EOF以降は読み込みが進まないので行数も変わらない
      expect(csv_io.lineno).to eq 4
    end
  end

  describe '#read' do
    it '引数無しならEOFまでの全てのデータを読み込んで、読み込んだ文字列を返す' do
      expect(csv_io.read).to eq "col1,col2,col3\n1,2,3\n4,5,6\n7,8,9\n"
    end
  end

  describe '#readline' do
    it '1行ずつ読み込み、EOFに到達した時はEOFErrorを発生させる' do
      expect(csv_io.readline).to eq "col1,col2,col3\n"
      expect(csv_io.readline).to eq "1,2,3\n"
      expect(csv_io.readline).to eq "4,5,6\n"
      expect(csv_io.readline).to eq "7,8,9\n"
      expect { csv_io.readline }.to raise_error EOFError, 'end of file reached'
    end
  end

  describe '#readlines' do
    it '全てのデータを読み込み、各行を要素として持つ配列を返す' do
      expect(csv_io.readlines).to eq ["col1,col2,col3\n", "1,2,3\n", "4,5,6\n", "7,8,9\n"]
    end
  end
end
