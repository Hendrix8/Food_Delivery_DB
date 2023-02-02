from faker import Faker
from faker_food import FoodProvider
from datetime import datetime, timedelta, time
from collections import Counter
import random

fake = Faker()
fake.add_provider(FoodProvider)

def customer(sample_size):
    customers = [] # a list that will store all the data that were generated

    generated_usernames = [] # a list that will store all the usernames that are generated
    generated_emails = []
    generated_phones = []
    for _ in range(sample_size):

            username = fake.user_name() # generating a user name 
            while username in generated_usernames: # if username is already generated
                username = fake.user_name() # generate a new one
            fname = fake.first_name() 
            lname = fake.last_name()
                            
            email = fake.email()
            while email in generated_emails:
                email = fake.email()

            phone = str(fake.random_int(1, 9999999999))           
            while phone in generated_phones:
                phone = str(fake.random_int(1, 9999999999))

            address = fake.address().replace('\n', ' ')
            address = address.replace(',', '')

            generated_usernames.append(username)
            generated_emails.append(email)
            generated_phones.append(phone)
            customers.append((username, fname, lname, email, phone, address))
    return customers

def restaurant(sample_size):
    restaurants = []

    gen_vats = []
    gen_names = []
    gen_locs = []
    for _ in range(sample_size):
        vat = str(fake.random_int(1, 999999999))
        while vat in gen_vats:
            vat = str(fake.random_int(1, 999999999))
        
        name = fake.company()
        while name in gen_names:
            name = str(fake.random_int(1, 999999999))
        
        address = fake.address().replace('\n', ' ')
        address = address.replace(',', '')
        while address in gen_locs:
            address = fake.address().replace('\n', ' ')
            address = address.replace(',', '')

        cuisine_types = ['Italian', 'Chinese', 'Mexican', 'Indian', 'American']
        cuisine_type = fake.random_element(cuisine_types)


        gen_locs.append(address)
        gen_names.append(name)
        gen_vats.append(vat)

        restaurants.append((vat, name, address, cuisine_type))
    return restaurants

def driver(sample_size):
    drivers = []
    
    gen_ssn = []
    gen_phones = []
    
    for _ in range(sample_size):

        ssn = str(fake.random_int(1,999999999))
        while ssn in gen_ssn:
            ssn = str(fake.random_int(1,99999999))
        
        fname = fake.first_name()
        lname = fake.last_name()

        phone = str(fake.random_int(1,9999999999))
        while phone in gen_phones:
            phone = str(fake.random_int(1,9999999999))

        address = fake.address().replace('\n', ' ')
        address = address.replace(',', '')
        
        status = fake.random_element([0,1])
        gender = fake.random_element([0,1])
        bdate = fake.date_of_birth().strftime("%Y-%m-%d %H:%M:%S")


        gen_ssn.append(ssn)
        gen_phones.append(phone)
        
        drivers.append((ssn, fname, lname, phone, address, status, gender, bdate))

    return drivers

def menu_item(sample_size, rest_list):
    menu_items = []

    gen_barcodes = [] 
    for _ in range(sample_size):

        barcode = str(fake.random_int(1,9999999999999))
        while barcode in gen_barcodes:
            barcode = str(fake.random_int(1,9999999999999))

        vat = fake.random_element([i[0] for i in rest_list])
        name = fake.dish()
        price = round(fake.random.uniform(5, 50),2)
        availability = fake.random_int(min=1, max=100, step=1)

        
        gen_barcodes.append(barcode)
        menu_items.append((barcode, vat, name, price, availability))
    
    return menu_items


def payment(sample_size, order_list=[]):

    payments = []
    
    trans_ids = []

    for order in order_list:
        receipt_num = order[0]
        trans_id = str(fake.random_int(1,999999999999))
        while trans_id in trans_ids:
            trans_id = str(fake.random_int(1,999999999999))
        
        payment_method = fake.credit_card_provider()
        if order[7] == -1:
            payment_status = -1
        else:
            payment_status = fake.random_element([0,1])
        
        trans_date = fake.date()

        trans_ids.append(trans_id)
        payments.append((trans_id, receipt_num, payment_method, payment_status, trans_date))
    
    return payments

def coupon(sample_size):
    coupons = [] 

    coupon_ids = [] 
    for _ in range(sample_size):
        

        coupon_id = str(fake.random_int(1,9999999999))
        while coupon_id in coupon_ids:
            coupon_id = str(fake.random_int(1,9999999999))

        coupon_code = fake.random_element(elements=("ABC", "DEF", "GHI", "JKL", "MNO", "PQR", "STU", "VWX", "YZ"))\
         + str(fake.random_int(min=100, max=999))
        discount = int(round(fake.random.random()*100,0))
        exp_date = fake.date()

        coupon_ids.append(coupon_id)
        coupons.append((coupon_id, coupon_code, discount, exp_date))
    
    return coupons


def rating(sample_size, reviewed=0, cust_list=[], driver_list=[], rest_list=[], item_list=[]):
    # reviewed 0 -> restaurant 
    # 1 -> driver 
    # 2 -> item
    rest_vat = None
    driver_ssn = None
    item_barcode = None
    review = None

    ratings = []

    rating_ids = []
    customer_usernames = []

    for _ in range(sample_size):

        rating_id = str(fake.random_int(1,9999999999))
        while rating_id in rating_ids:
            rating_id = str(fake.random_int(1,9999999999))

        customer_username = fake.random_element([i[0] for i in cust_list])
        
        
        if reviewed == 0:
            rest_vat = fake.random_element([i[0] for i in rest_list])
        elif reviewed == 1:
            driver_ssn = fake.random_element([i[0] for i in driver_list])
        else:
            item_barcode = fake.random_element([i[0] for i in item_list])
        
        rating_num = fake.random_element([1,2,3,4,5])
        
        if fake.random.random() > 0.5:
            review = fake.paragraph()

    
        rating_ids.append(rating_id)
        customer_usernames.append(customer_username)
        ratings.append((rating_id, customer_username, rest_vat, driver_ssn, item_barcode, rating_num, review))
    
    return ratings

def owner(sample_size):
    owners = []
    ssns = []
    phones = []

    for _ in range(sample_size):

        ssn = str(fake.random_int(1,999999999))
        while ssn in ssns:
            ssn = str(fake.random_int(1,999999999))

        fname = fake.first_name()
        lname = fake.last_name()

        phone = str(fake.random_int(1,9999999999))
        while phone in phones:
            phone = str(fake.random_int(1,9999999999))

        address = fake.address().replace('\n', ' ')
        address = address.replace(',', '')

        gender = fake.random_element([0,1])
        bdate = fake.date()
        email = fake.email()

        ssns.append(ssn)
        phones.append(phone)
        owners.append((ssn, fname, lname, phone, email, address, gender, bdate))
    return owners


def order(sample_size, cust_list=[], rest_list=[], payment_list=[], coupon_list=[], item_list=[]):

    orders = []
    receipt_nums = []
    cust_usernames = []
    coupon_id = None
    order_items = []
    costs = []

    for _ in range(sample_size):

        receipt_num = str(fake.random_int(1,9999999999))
        while receipt_num in receipt_nums:
            receipt_num = str(fake.random_int(1,9999999999))

        customer_username = fake.random_element([i[0] for i in cust_list])
        rest_vat = fake.random_element([i[0] for i in rest_list])

        if coupon_list != []:
            if random.random() > 0.3:
                coupon_id = fake.random_element(i[0] for i in coupon_list)

        del_add = fake.address().replace('\n', ' ')
        del_add = del_add.replace(',', '')

        item_num = fake.random_element([i for i in range(1,3)])
        for _ in range(item_num):
            
            order_item = fake.random_element(item_list)
            
            order_items.append(order_item)
            costs.append(order_item[3])


        total_cost = sum(costs)


        order_date = fake.date()

        status = fake.random_element([-1,0,1])


        cust_usernames.append(customer_username)
        receipt_nums.append(receipt_num)
        orders.append((receipt_num, customer_username, rest_vat, coupon_id, del_add, total_cost, order_date, status ))
    return orders, order_items

def includes(receipt_num, order_items):

    item_counts = dict(Counter(order_items))

    includents = []
    items = list(item_counts.keys())

    for i in items:
        item_barcode = i
        quantity = item_counts[i]
        
        includents.append((item_barcode, receipt_num, quantity))
    return includents
        

def delivers(order_list, driver_list):
    deliveries = []

    for i in order_list:
        if i[-1] != -1:
            receipt_num = i[0]
            ssn = fake.random_element([i[0] for i in driver_list])

            start_time = fake.time_object()
            time_delta = timedelta(hours=2)
            start_datetime = datetime.combine(datetime.today(), start_time)
            end_datetime = start_datetime + time_delta

            start_time = start_time.strftime("%H:%M:%S")
            end_time = end_datetime.time().strftime("%H:%M:%S")
            distance = fake.random.uniform(0, 100)

            random_money = random.randint(1,50)
            random_cent = round(random.uniform(0, 1), 2)
            
            tips = random_money + random_cent

            deliveries.append((receipt_num, ssn, start_time, end_time, round(distance,2), round(tips,2)))
    
    return deliveries


def owns(rest_list, owner_list):

    owned = []

    for r in rest_list:
        vat = str(r[0])
        owner_ssn = fake.random_element([i[0] for i in owner_list])
        start_date = fake.date()
        hours = random.randint(20,1000)

        random_money = random.randint(1000,1000000)
        random_cent = round(random.uniform(0, 1), 2)
        investment = random_money + random_cent

        owned.append((vat, owner_ssn, start_date, hours, investment))

    return owned


if __name__ == "__main__":

    customers = customer(100) 
    owners = owner(12)
    restaurants = restaurant(20)
    drivers = driver(100)
    coupons = coupon(5)
    menu_items = menu_item(1000, rest_list=restaurants)

    ratings1 = rating(200, 0, cust_list=customers, rest_list=restaurants)
    ratings2 = rating(200, 1, cust_list=customers, driver_list=drivers)
    ratings3 = rating(200, 2, cust_list=customers, item_list=menu_items)

    orders = order(1000, cust_list=customers, rest_list=restaurants, coupon_list=coupons, item_list=menu_items)

    payments = payment(1000, order_list = orders[0])

    
    deliveries = delivers(orders[0], driver_list=drivers)
    
    includents = []
    for order, order_items in zip(orders[0],orders[1]):
        inc = includes(order[0], order_items=order_items)
        includents.append(inc[0])
    
    owned = owns(rest_list=restaurants, owner_list=owners)
    print(orders[0])
