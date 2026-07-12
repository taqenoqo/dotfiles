#!/usr/bin/env ruby
# 規模メトリクス: 定義一覧 (defs.tsv) から、レポートのセクション
# 「規模メトリクス」の本文を markdown で stdout に出力する。
# 数え上げを LLM にやらせないための関門で、レポート中の数値はすべてここ由来とする。

TOP_N = 10

Def = Struct.new(:path, :kind, :name, :parent, :visibility,
                 :exported, :first_line, :last_line, :signature) do
  def lines
    last_line.to_i - first_line.to_i + 1
  end

  def full_name
    parent == '-' ? name : "#{parent}.#{name}"
  end
end

class MetricsReport
  def initialize(defs)
    @defs = defs
  end

  def output
    function_length_section
    class_size_section
    class_distribution_section
  end

  private

  def function_length_section
    section '関数・メソッドの長さ',
            "対象 #{funcs.size} 件 / 最大 #{funcs.map(&:lines).max || 0} 行"
    table %w[場所 名前 行数], longest_functions
  end

  def class_size_section
    section 'クラスの規模',
            "クラス総数 #{classes.size} / 定義の可視性: " \
            "public #{count_visibility('public')}, private #{count_visibility('private')}"
    table %w[場所 クラス メソッド数], methods_per_class
  end

  def class_distribution_section
    section 'クラスの分布'
    table %w[ファイル クラス数], classes_per_file
    table %w[ディレクトリ クラス数], classes_per_directory
  end

  # 表の行データ。列は「場所 → 名前 → 数値」の順。
  # 行は数値の大きい順、同数は場所・名前の辞書順 (再生成しても行順が揺れないように)

  def longest_functions
    funcs
      .sort_by { |f| [-f.lines, f.path, f.full_name] }
      .map { |f| [f.path, "`#{f.full_name}`", f.lines] }
  end

  def methods_per_class
    methods = funcs.select { |f| f.kind == 'method' && f.parent != '-' }
    methods
      .group_by { |m| [m.path, m.parent] }
      .map { |(path, parent), ms| [path, "`#{parent}`", ms.size] }
      .sort_by { |path, name, count| [-count, path, name] }
  end

  def classes_per_file
    classes
      .group_by(&:path)
      .map { |path, cs| [path, cs.size] }
      .sort_by { |path, count| [-count, path] }
  end

  def classes_per_directory
    classes
      .group_by { |c| File.dirname(c.path) }
      .map { |dir, cs| ["#{dir}/", cs.size] }
      .sort_by { |dir, count| [-count, dir] }
  end

  def funcs
    @defs.select { |d| %w[func method].include?(d.kind) }
  end

  def classes
    @defs.select { |d| d.kind == 'class' }
  end

  def count_visibility(visibility)
    @defs.count { |d| d.visibility == visibility }
  end

  def section(title, summary = nil)
    puts "### #{title}", ''
    puts "- #{summary}", '' if summary
  end

  def table(header, rows)
    puts "| #{header.join(' | ')} |"
    puts "|#{'---|' * header.size}"
    rows.first(TOP_N).each { |row| puts "| #{row.join(' | ')} |" }
    puts
  end
end

defs = File.readlines(ARGV.fetch(0)).map { |line| Def.new(*line.chomp.split("\t", 9)) }
MetricsReport.new(defs).output
