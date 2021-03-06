module BulkUploader
  def self.upload(file, type)
      case type
      when 'Vendors'
        avatar = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/avatar.jpg'), 'image/jpg')
        image  = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/laundry.jpg'), 'image/jpg')
        Vendor.transaction do
          CSV.foreach(file.tempfile, headers: true) do |row|
            begin
              vendor = Vendor.new(row.to_hash)
              vendor.avatar = avatar
              vendor.images = [image]
              vendor.save!
            rescue ActiveRecord::RecordInvalid
              return [true, vendor.errors.full_messages]
            end
          end
        end
      when 'Items'
        Item.transaction do
          CSV.foreach(file.tempfile, headers: true) do |row|
            begin
              item = Item.new(row.to_hash)
              item.save!
            rescue ActiveRecord::RecordInvalid
              return [true, item.errors.full_messages]
            end
          end
        end
      when 'Schedules'
        Schedule.transaction do
          CSV.foreach(file.tempfile, headers: true) do |row|
            begin
              schedule = Schedule.new(row.to_hash)
              schedule.save!
            rescue ActiveRecord::RecordInvalid
              return [true, schedule.errors.full_messages]
            end
          end
        end
      when 'Inventory Items'
        InventoryItem.transaction do
          CSV.foreach(file.tempfile, headers: true) do |row|
            begin
              inventory_item = InventoryItem.new(row.to_hash)
              inventory_item.save!
            rescue ActiveRecord::RecordInvalid
              return [true, inventory_item.errors.full_messages]
            end
          end
        end
      when 'Shipping Methods'
        ShippingMethod.transaction do
          CSV.foreach(file.tempfile, headers: true) do |row|
            begin
              shipping_method = ShippingMethod.new(row.to_hash)
              shipping_method.save!
            rescue ActiveRecord::RecordInvalid
              return [true, shipping_method.errors.full_messages]
            end
          end
        end
      end
  end
end
