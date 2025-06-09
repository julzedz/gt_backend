require 'prawn'

class TransactionReceiptPdf < Prawn::Document
  def initialize(transaction)
    super(page_size: 'A4', margin: 50)
    @transaction = transaction
    font_families.update("Inter" => {
      normal: Rails.root.join("app/assets/fonts/Inter-Regular.ttf").to_s,
      bold: Rails.root.join("app/assets/fonts/Inter-Bold.ttf").to_s,
      italic: Rails.root.join("app/assets/fonts/Inter-Italic.ttf").to_s,
      bold_italic: Rails.root.join("app/assets/fonts/Inter-BoldItalic.ttf").to_s
    })
    font "Inter"
    header
    transaction_details
    user_details
    footer
  end

  def header
    text "GT Savings Bank", size: 28, style: :bold, align: :center, color: "3366CC"
    move_down 10
    text "Transaction Receipt", size: 22, style: :bold, align: :center
    move_down 20
    stroke_horizontal_rule
    move_down 20
  end

  def transaction_details
    text "Transaction Details", size: 14, style: :bold
    move_down 10

    data = [
      ["Reference ID:", @transaction.reference_id],
      ["Date:", format_datetime(@transaction.created_at)],
      ["Type:", { content: @transaction.transaction_type.titleize, color: type_color(@transaction.transaction_type) }],
      ["Amount:", "₦#{@transaction.amount}"],
      ["Status:", { content: @transaction.status.titleize, color: status_color(@transaction.status) }]
    ]

    if @transaction.description.present?
      data << ["Description:", @transaction.description]
    end

    table(data, width: 500) do
      style(columns[0], width: 150, font_style: :bold)
      style(columns[1], width: 350)
      row(2).columns(1).text_color = type_color(@transaction.transaction_type)
      row(4).columns(1).text_color = status_color(@transaction.status)
    end
    move_down 30
  end

  def user_details
    text "User Details", size: 14, style: :bold
    move_down 10

    data = [
      ["Name:", "#{@transaction.user.first_name} #{@transaction.user.last_name}"],
      ["Account Number:", @transaction.user.account_number],
      ["Email:", @transaction.user.email]
    ]

    table(data, width: 500) do
      style(columns[0], width: 150, font_style: :bold)
      style(columns[1], width: 350)
    end
    move_down 30
  end

  def footer
    stroke_horizontal_rule
    move_down 10
    text "Thank you for banking with us!", size: 12, align: :center, style: :italic, color: "666666"
    move_down 5
    text "Generated on: #{Time.current.strftime("%Y-%m-%d %H:%M:%S")}", size: 8, align: :center
  end

  private

  def format_datetime(datetime)
    datetime.strftime("%a, %b %e, %Y %l:%M %p")
  end

  def type_color(type)
    type == "debit" ? "FF0000" : "008000" # Red for debit, Green for credit
  end

  def status_color(status)
    case status
    when "processed" then "008000" # Green
    when "pending"   then "FFA500" # Orange/Yellow
    when "failed"    then "FF0000" # Red
    else "000000" # Black (default)
    end
  end
end 