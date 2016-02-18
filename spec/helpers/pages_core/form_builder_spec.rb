# encoding: utf-8

require "rails_helper"

describe PagesCore::FormBuilder do
  let(:template) { self }
  let(:resource) { build(:user) }
  let(:builder) { PagesCore::FormBuilder.new(:user, resource, template, {}) }

  describe "#errors_on?" do
    subject { builder.errors_on?(:email) }

    it { is_expected.to eq(false) }

    context "with errors" do
      let(:resource) { User.new.tap(&:validate) }
      it { is_expected.to eq(true) }
    end
  end

  describe "#errors_on" do
    subject { builder.errors_on(:email) }

    it { is_expected.to eq([]) }

    context "with errors" do
      let(:resource) { User.new.tap(&:validate) }
      it { is_expected.to eq(["kan ikke være blank", "er ugyldig"]) }
    end
  end

  context "#first_error_on" do
    subject { builder.first_error_on(:email) }

    it { is_expected.to eq(nil) }

    context "with errors" do
      let(:resource) { User.new.tap(&:validate) }
      it { is_expected.to eq("kan ikke være blank") }
    end
  end

  describe "#image_file_field" do
    let(:template) { spy }

    it "should render an image field" do
      builder.image_file_field(:image)
      expect(template).to have_received(:file_field)
        .with(:user, :image, object: resource)
    end

    context "with image" do
      let(:image) { create(:image) }
      let(:resource) { create(:user, image: image) }
      it "should render the image" do
        builder.image_file_field(:image)
        expect(template).to have_received(:dynamic_image_tag)
          .with(image, size: "120x100")
        expect(template).to have_received(:file_field)
          .with(:user, :image, object: resource)
      end
    end
  end

  describe "#field_with_label" do
    subject { builder.field_with_label(:email, "content") }
    it "should render the field" do
      expect(subject).to eq(
        "<div class=\"field\"><label for=\"user_email\">Email</label>" \
          "content</div>"
      )
    end

    context "when field has errors" do
      let(:resource) { User.new.tap(&:validate) }
      it { is_expected.to match("class=\"field field-with-errors\"") }
    end
  end

  describe "#label_for" do
    subject { builder.label_for(:email) }

    it { is_expected.to eq("<label for=\"user_email\">Email</label>") }

    context "with a label" do
      subject { builder.label_for(:email, "Foo") }
      it { is_expected.to eq("<label for=\"user_email\">Foo</label>") }
    end

    context "with errors" do
      let(:resource) { User.new.tap(&:validate) }
      it "should output the error" do
        expect(subject).to match(
          "<span class=\"error\">kan ikke være blank</span>"
        )
      end
    end
  end

  describe "#labelled_text_field" do
    let(:template) { spy }
    it "should render the field" do
      builder.labelled_text_field(:email, size: 20)
      expect(template).to have_received(:text_field)
        .with(:user, :email, object: resource, size: 20)
    end
  end

  describe "#labelled_text_area" do
    let(:template) { spy }
    it "should render the field" do
      builder.labelled_text_area(:email)
      expect(template).to have_received(:text_area)
        .with(:user, :email, object: resource)
    end
  end

  describe "#labelled_country_select" do
    it "should render the field" do
      allow(builder).to receive(:country_select)
      builder.labelled_country_select(:email)
      expect(builder).to have_received(:country_select)
        .with(:email, {}, {}, {})
    end
  end

  describe "#labelled_date_select" do
    let(:template) { spy }
    it "should render the field" do
      builder.labelled_date_select(:created_at)
      expect(template).to have_received(:date_select)
        .with(:user, :created_at, { object: resource }, {})
    end
  end

  describe "#labelled_datetime_select" do
    let(:template) { spy }
    it "should render the field" do
      builder.labelled_datetime_select(:created_at)
      expect(template).to have_received(:datetime_select)
        .with(:user, :created_at, { object: resource }, {})
    end
  end

  describe "#labelled_time_select" do
    let(:template) { spy }
    it "should render the field" do
      builder.labelled_time_select(:created_at)
      expect(template).to have_received(:time_select)
        .with(:user, :created_at, { object: resource }, {})
    end
  end

  describe "#labelled_select" do
    let(:template) { spy }
    let(:options) { %w(Foo Bar) }
    it "should render the field" do
      builder.labelled_select(:email, options)
      expect(template).to have_received(:select)
        .with(:user, :email, options, { object: resource }, {})
    end
  end

  describe "#labelled_check_box" do
    let(:template) { spy }
    it "should render the field" do
      builder.labelled_check_box(:activated)
      expect(template).to have_received(:check_box)
        .with(:user, :activated, { object: resource }, "1", "0")
    end
  end

  describe "#labelled_image_file_field" do
    let(:template) { spy }
    it "should render the field" do
      builder.labelled_image_file_field(:image)
      expect(template).to have_received(:file_field)
        .with(:user, :image, object: resource)
    end
  end

  describe "#labelled_password_field" do
    let(:template) { spy }
    it "should render the field" do
      builder.labelled_password_field(:email)
      expect(template).to have_received(:password_field)
        .with(:user, :email, object: resource)
    end
  end
end