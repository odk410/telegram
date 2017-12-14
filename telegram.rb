require 'httparty'
require 'awesome_print' #이것은 HTML문서를 보기 좋게 만들어준다.
require 'json'
require 'uri' #메시지 보낼때 한글을 보내기 위해서
require 'nokogiri'

#response = HTTParty.get("https://api.telegram.org/bot502545483:AAHF-LWR-XLUB9FYdPvQUKbyT23koCJQJGw/getUpdates")를
#아래와 같이 나누어주기

token = "502545483:AAHF-LWR-XLUB9FYdPvQUKbyT23koCJQJGw"
url = "https://api.telegram.org/bot"

response = HTTParty.get("#{url}#{token}/getUpdates")


# ap는 awesom_print를 사용하겠다는 의미이다.
# puts response
# JSON을 Ruby의 Hash로 바꿔준다.
hash = JSON.parse(response.body)
# 아래처럼 해주면 보기 좋게 코드가 나온다.
# api에서 원하는 값 뽑기. chat_id 뽑기
# ap hash["result"][0]["message"]["from"]["id"]
chat_id = hash["result"][0]["message"]["from"]["id"]

msg = "작동되냐?"
encoded = URI.encode(msg)

# KOSPI 지수 스크랩
res = HTTParty.get("http://finance.naver.com/sise/")
html = Nokogiri::HTML(res.body)
kospi = html.css('#KOSPI_now').text

msg = "오늘 코스피 지수는 #{kospi}"
encoded = URI.encode(msg)

# 로또 API로 로또 번호 가져오기
res = HTTParty.get("http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=784")
lotto = JSON.parse(res.body)

lucky = []

6.times do |n|
  lucky << lotto["drwtNo#{n+1}"]
end

winner = lucky.to_s + " 보너스 번호 : " +lotto["bnusNo"].to_s

msg = "로또 번호는 : #{winner}"
encoded = URI.encode(msg)


while true
  HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
  #몇 초간 쉬고 동작해라
  sleep(3)
end
