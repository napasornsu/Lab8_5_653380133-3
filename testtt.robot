*** Settings ***
# นำ Resource ที่ใช้ร่วมกันเข้ามา เช่น ตัวแปร หรือ Keywords ที่ใช้บ่อย
Resource    ../UAT_resource.robot

# Suite Teardown: คำสั่งที่รันหลังจาก Test Cases ทั้งหมดเสร็จสิ้น ในที่นี้ใช้ปิดเบราว์เซอร์
Suite Teardown  Close Browser

*** Keywords ***
# เปิดเบราว์เซอร์และนำไปยังหน้า Form
Open Browser To Form Page
    Open Browser    ${URL}    chrome  # เปิดเบราว์เซอร์ Google Chrome และไปยัง URL ที่กำหนด
    Maximize Browser Window            # ปรับหน้าต่างเบราว์เซอร์ให้เต็มหน้าจอ

# กรอกข้อมูลในฟอร์ม
Fill Form
    [Arguments]    ${firstname}    ${lastname}    ${destination}    ${contactperson}    ${relationship}    ${email}    ${phone}
    # ใส่ข้อความในแต่ละฟิลด์ของฟอร์ม โดยใช้ id ในการระบุฟิลด์
    Input Text    id=firstname         ${firstname}      # กรอกชื่อในฟิลด์ firstname
    Input Text    id=lastname          ${lastname}       # กรอกนามสกุลในฟิลด์ lastname
    Input Text    id=destination       ${destination}    # กรอกปลายทางในฟิลด์ destination
    Input Text    id=contactperson     ${contactperson}  # กรอกชื่อผู้ติดต่อในฟิลด์ contactperson
    Input Text    id=relationship      ${relationship}   # กรอกความสัมพันธ์ในฟิลด์ relationship
    Input Text    id=email             ${email}          # กรอกอีเมลในฟิลด์ email
    Input Text    id=phone             ${phone}          # กรอกเบอร์โทรศัพท์ในฟิลด์ phone
    Click Button    id=submitButton                    # กดปุ่ม Submit เพื่อส่งข้อมูล

# ตรวจสอบว่ามีข้อความแจ้งเตือนปรากฏอยู่หรือไม่
Verify Error Message
    [Arguments]    ${expected_message}
    Page Should Contain    ${expected_message}  # ตรวจสอบว่าหน้าจอมีข้อความแจ้งเตือนตรงกับที่คาดหวัง

*** Test Cases ***
# ทดสอบการเปิดหน้า Form
1. Open Form
    [Documentation]    Opens the form page and verifies that the form is displayed.
    Open Browser To Form Page  # เปิดหน้า Form

# ทดสอบกรณีที่ฟิลด์ Destination ว่าง
2. Empty Destination
    [Documentation]    Verifies error when "Destination" is empty.
    Open Browser To Form Page                        # เปิดหน้า Form
    Fill Form    Somsong    Sandee    ${EMPTY}       # กรอกฟอร์มโดยปล่อยฟิลด์ destination ว่าง Sodsai Sandee    Mother    somsong@kkumail.com    081-111-1234
    Verify Error Message    Please enter your destination.  # ตรวจสอบข้อความแจ้งเตือน

# ทดสอบกรณีที่ฟิลด์ Email ว่าง
3. Empty Email
    [Documentation]    Verifies error when "Email" is empty.
    Open Browser To Form Page                        # เปิดหน้า Form
    Fill Form    Somsong    Sandee    Europe         # กรอกฟอร์มโดยปล่อยฟิลด์ email ว่าง Sodsai Sandee    Mother    ${EMPTY}    081-111-1234
    Verify Error Message    Please enter a valid email address.  # ตรวจสอบข้อความแจ้งเตือน

# ทดสอบกรณีที่ Email ไม่สมบูรณ์
4. Invalid Email
    [Documentation]    Verifies error when "Email" is invalid.
    Open Browser To Form Page                        # เปิดหน้า Form
    Fill Form    Somsong    Sandee    Europe         # กรอกอีเมลผิดรูปแบบ Sodsai Sandee    Mother    somsong@    081-111-1234
    Verify Error Message    Please enter a valid email address.  # ตรวจสอบข้อความแจ้งเตือน

# ทดสอบกรณีที่ฟิลด์ Phone Number ว่าง
5. Empty Phone Number
    [Documentation]    Verifies error when "Phone Number" is empty.
    Open Browser To Form Page                        # เปิดหน้า Form
    Fill Form    Somsong    Sandee    Europe         # กรอกฟอร์มโดยปล่อยฟิลด์ phone ว่าง Sodsai Sandee    Mother    somsong@kkumail.com    ${EMPTY}
    Verify Error Message    Please enter a phone number.  # ตรวจสอบข้อความแจ้งเตือน

# ทดสอบกรณีที่ Phone Number ไม่ถูกต้อง
6. Invalid Phone Number
    [Documentation]    Verifies error when "Phone Number" is invalid.
    Open Browser To Form Page                        # เปิดหน้า Form
    Fill Form    Somsong    Sandee    Europe         # กรอกเบอร์โทรผิดรูปแบบ เช่น 191 Sodsai Sandee    Mother    somsong@kkumail.com    191
    Verify Error Message    Please enter a valid phone number, e.g., 081-234-5678, 081 234 5678, or 081.234.5678.  # ตรวจสอบข้อความแจ้งเตือน
