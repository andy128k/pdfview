class DocumentsController < ApplicationController
  def index
    @documents = []
    documents = "#{Rails.root}/public/docs"
    Dir.foreach(documents) do |entry|
      file = "#{documents}/#{entry}"
      if File.file?(file) and File.readable?(file)
        @documents << entry
      end
    end
  end

  def show
    @filename = params[:filename]
    uri = "#{Rails.root}/public/docs/#{@filename}"
    @doc = Poppler::Document.new uri
    
    @page_num = (params[:p] || 1).to_i

    @actions = []
    walk_index(@actions, @doc.index_iter, 0)

    @page = @doc.get_page(@page_num - 1)

    scale = 1
    @page_hash = Digest::MD5.hexdigest "#{@filename}|#{@page_num}|#{scale}"
    page_file = "#{Rails.root}/public/pages/#{@page_hash}.png"

    crop_box = @page.crop_box
    @page_width = crop_box.x2 - crop_box.x1
    @page_height = crop_box.y2 - crop_box.y1

    if not File.exists? page_file
      pixbuf = Gdk::Pixbuf.new(Gdk::Pixbuf::COLORSPACE_RGB, false, 8, @page_width, @page_height)
      @page.render(crop_box.x1, crop_box.y1, @page_width, @page_height, scale, 0, pixbuf)
      pixbuf.save page_file, "png"
    end

    @text_blocks = []
    layout = @page.text_layout()
    if layout
      layout.each do |rect|
        @text_blocks << {
          :text => @page.get_text(rect),
          :x => rect.x1 - crop_box.x1,
          :y => rect.y1 - crop_box.y1,
          :width => rect.x2 - rect.x1,
          :height => rect.y2 - rect.y1,
        }
      end
    end
  end

  private

  def walk_index(actions, i, indent)
    while i.valid? do
      if i.action.kind_of? Poppler::ActionGotoDest
        actions << [i.action, indent]
      end
      child = i.child
      if child
        walk_index(actions, child, indent + 1)
      end
      b = i.next
      break unless b
    end
  end

end

