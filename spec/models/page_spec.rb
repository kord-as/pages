require 'spec_helper'

describe Page do
  describe 'with parents' do
    before do
      @root   = Page.create
      @parent = Page.create(:parent => @root)
      @page   = Page.create(:parent => @parent)
    end

    it 'belongs to the parent' do
      @page.parent.should == @parent
    end

    it 'should be a child of root' do
      @page.is_child_of(@root).should be_true
    end
  end

  describe 'setting multiple locales' do
    before do
      @page = Page.create(:excerpt => {'en' => 'My test page', 'nb' => 'Testside'}, :locale => 'en')
    end

    it 'should respond with the locale specific string' do
      @page.excerpt?.should be_true
      @page.excerpt.to_s.should == 'My test page'
      @page.translate('nb').excerpt.to_s.should == 'Testside'
    end
  end

  describe 'with an excerpt' do
    before do
      @page = Page.create(:excerpt => 'My test page', :locale => 'en')
    end

    it 'responds to excerpt?' do
      @page.excerpt?.should be_true
      @page.excerpt = nil
      @page.excerpt?.should be_false
    end

    it 'excerpt should be a localization' do
      @page.excerpt.should be_kind_of(Localization)
      @page.excerpt.to_s.should == 'My test page'
    end

    it 'should be changed when saved' do
      @page.update_attribute(:excerpt, 'Hi')
      @page.reload
      @page.excerpt.to_s.should == 'Hi'
    end

    it 'should remove the localization when nilified' do
      @page.update_attribute(:excerpt, nil)
      @page.valid?.should be_true
      @page.reload
      @page.excerpt?.should be_false
    end
  end
end