class Admin::ImageSerializer < ActiveModel::Serializer
  attributes(
    :id, :filename, :content_type, :content_hash, :content_length,
    :colorspace, :real_width, :real_height, :crop_width, :crop_height,
    :crop_start_x, :crop_start_y, :crop_gravity_x, :crop_gravity_y,
    :caption, :created_at, :updated_at
  )
end