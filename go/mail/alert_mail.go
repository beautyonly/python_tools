package funcs

import (
	"encoding/json"
	"fmt"
	"os"
	"strings"
	"net/smtp"

)

type configuration struct {
	Enabled bool
	Mail_smtp_host string
	Mail_smtp_user string
	Mail_smtp_pass string
	Mail_to string
}

func SendToMail (user, password, host, to, subject, body, mailtype string) error {
	hp := strings.Split(host, ":")
	auth := smtp.PlainAuth("", user, password, hp[0])
	var content_type string
	if mailtype == "html" {
		content_type = "Content-Type: text/" + mailtype + "; charset=UTF-8"
	} else {
		content_type = "Content-Type: text/plain" + "; charset=UTF-8"
	}

	msg := []byte("To: " + to + "\r\nFrom: " + user + ">\r\nSubject: " + "\r\n" + content_type + "\r\n\r\n" + body)
	send_to := strings.Split(to, ";")
	err := smtp.SendMail(host, auth, user, send_to, msg)
	return err
}

func main() {
	file, _ := os.Open("alert_config.json")
	defer file.Close()

	decoder := json.NewDecoder(file)
	conf := configuration{}
	err := decoder.Decode(&conf)
	if err != nil {
		fmt.Println("Error:", err)
	}

	user := conf.Mail_smtp_user
	password := conf.Mail_smtp_pass
	host := conf.Mail_smtp_host
	to := conf.Mail_to

	subject := "使用Golang发送邮件"

	body := `
		<html>
		<body>
		<h3>
		"Test send to email"
		</h3>
		</body>
		</html>
		`
	fmt.Println("send email")
	mail_err := SendToMail(user, password, host, to, subject, body, "html")
	if mail_err != nil {
		fmt.Println("Send mail error!")
		fmt.Println(mail_err)
	} else {
		fmt.Println("Send mail success!")
	}
}