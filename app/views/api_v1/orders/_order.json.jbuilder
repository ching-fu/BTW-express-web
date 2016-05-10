json.id order.id
json.category order.category
json.photo order.photo

json.fee order.detail.fee
json.prepay order.detail.prepay
json.description order.detail.description

json.pickup_addr order.pickup_addr
json.pickup_latlng order.pickup_latlng
json.pickup_time order.pickup_time

json.deliver_addr order.deliver_addr
json.deliver_latlng order.deliver_latlng
json.deliver_time order.deliver_time
if order.courier_id
	json.senderName User.find(order.courier_id).fullname
	json.senderPhone User.find(order.courier_id).phone
end
json.receiverName order.detail.addressees_name
json.receiverPhone order.detail.addressees_mobile
