require 'aws-sdk-s3'
require 'net/http'
require 'uri'
require 'date'

BUCKET = ENV['BUCKET']

BASE_URI = 'http://www.data.jma.go.jp/fcd/yoho/gyogyou/'

def handler(event:, context:)
  save('jikkyo12.txt')
  save('tsuho12.txt')
end

def save(filename)
  res = Net::HTTP.get URI.parse(BASE_URI + filename)
  key = Date.today.strftime('%Y/%m/%d-') + filename

  client = Aws::S3::Client.new
  client.put_object({
    body: res.encode('UTF-8', 'Shift_JIS'),
    bucket: BUCKET,
    key: key
  })
end
