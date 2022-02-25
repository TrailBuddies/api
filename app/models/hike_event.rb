require 'httparty'
require 'tempfile'
require 'rmagick'

class HikeEvent < ApplicationRecord
  has_one_attached :image, dependent: :destroy
  before_create :generate_image
  before_destroy :purge_image

  def image_url
    Cloudinary::Utils.cloudinary_url(self.image.key)
  end

  def generate_image
    res = HTTParty.get('https://api.tomtom.com/map/1/staticimage', query: {
      key: ENV['TOMTOM_API_KEY'],
      layer: 'basic',
      style: 'main',
      format: 'png',
      center: "#{self.lat},#{self.lng}",
      width: '1024',
      height: '336',
      zoom: '12',
    });

    if res.code == 200
      Tempfile.create do |tmp|
        File.open(tmp.path, 'w+b') do |file|
          file.write(res);
          file.rewind;
          file.close;
        end

        withPin = Magick::Image.read(tmp.path).first.composite(Magick::Image.read('assets/pin.png').first, Magick::CenterGravity, Magick::OverCompositeOp)
        withPin.write(tmp.path)

        self.image.attach(io: File.open(tmp.path), filename: 'pin.png')
      end
    end
  end

  def purge_image
    self.image.purge
  end
end
