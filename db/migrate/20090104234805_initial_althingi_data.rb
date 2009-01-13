class InitialAlthingiData < ActiveRecord::Migration
  def self.up
    c = Category.new
    c.name = "Stjórnskipunarlög o.fl."
    c.save

    c = Category.new
    c.name = "Mannréttindi"
    c.save

    c = Category.new
    c.name = "Forseti Íslands"
    c.save

    c = Category.new
    c.name = "Alþingi og lagasetning"
    c.save

    c = Category.new
    c.name = "Dómstólar og réttarfar"
    c.save

    c = Category.new
    c.name = "Framkvæmdarvaldið"
    c.save

    c = Category.new
    c.name = "Sveitarfélög"
    c.save

    c = Category.new
    c.name = "Opinberir starfsmenn"
    c.save

    c = Category.new
    c.name = "Stjórnsýsla"
    c.save

    c = Category.new
    c.name = "Almannaskráning, hagskýrslur o.fl."
    c.save

    c = Category.new
    c.name = "Ríkisfjármál og ríkisábyrgðir"
    c.save

    c = Category.new
    c.name = "Eignir og framkvæmdir ríkisins"
    c.save

    c = Category.new
    c.name = "Skattar og gjöld"
    c.save

    c = Category.new
    c.name = "Utanríkismál og ýmsar alþjóðastofnanir"
    c.save

    c = Category.new
    c.name = "Öryggismál"
    c.save

    c = Category.new
    c.name = "Ríkisborgararéttur, útlendingar o.fl."
    c.save

    c = Category.new
    c.name = "Löggæsla og almannavarnir"
    c.save

    c = Category.new
    c.name = "Refsilög, fangelsismál o.fl."
    c.save

    c = Category.new
    c.name = "Fjársafnanir, happdrætti o.fl."
    c.save

    c = Category.new
    c.name = "Trúfélög og kirkjumál"
    c.save

    c = Category.new
    c.name = "Menntun, æskulýðsstarfsemi og íþróttir"
    c.save

    c = Category.new
    c.name = "Menningarmál"
    c.save

    c = Category.new
    c.name = "Fjölmiðlun"
    c.save

    c = Category.new
    c.name = "Heilbrigðismál"
    c.save

    c = Category.new
    c.name = "Almannatryggingar, félagsþjónusta o.fl."
    c.save

    c = Category.new
    c.name = "Vinnuréttur"
    c.save

    c = Category.new
    c.name = "Atvinnurekstur"
    c.save

    c = Category.new
    c.name = "Verslun og viðskipti"
    c.save

    c = Category.new
    c.name = "Bankar og fjármálafyrirtæki"
    c.save

    c = Category.new
    c.name = "Vátryggingar"
    c.save

    c = Category.new
    c.name = "Iðnaður"
    c.save

    c = Category.new
    c.name = "Náttúruauðlindir og orkumál"
    c.save

    c = Category.new
    c.name = "Sjávarútvegur, fiskveiðar og fiskirækt"
    c.save

    c = Category.new
    c.name = "Landbúnaður"
    c.save

    c = Category.new
    c.name = "Umhverfismál"
    c.save

    c = Category.new
    c.name = "Mannvirkjagerð, húsnæðismál og brunamál"
    c.save

    c = Category.new
    c.name = "Samgöngur og vöruflutningar"
    c.save

    c = Category.new
    c.name = "Póstur, sími og fjarskipti"
    c.save

    c = Category.new
    c.name = "Ferðaþjónusta, veitingastarfsemi o.fl."
    c.save

    c = Category.new
    c.name = "Persónuréttindi"
    c.save

    c = Category.new
    c.name = "Málefni barna"
    c.save

    c = Category.new
    c.name = "Sifjaréttindi"
    c.save

    c = Category.new
    c.name = "Erfðaréttindi"
    c.save

    c = Category.new
    c.name = "Kröfuréttindi"
    c.save

    c = Category.new
    c.name = "Félög, firmu og stofnanir"
    c.save

    c = Category.new
    c.name = "Hlutaréttindi"
    c.save

    c = Category.new
    c.name = "Hugverka- og einkaréttindi"
    c.save
 
    dt = DocumentType.new
    dt.document_type = "Lagafrumvarp"
    dt.save

    dt = DocumentType.new
    dt.document_type = "Lög"
    dt.save

    dt = DocumentType.new
    dt.document_type = "Breytingartillaga"
    dt.save

    dt = DocumentType.new
    dt.document_type = "Vinnuhópaálit"
    dt.save

    dt = DocumentType.new
    dt.document_type = "Breytingartillaga frá almenningi"
    dt.save

    ds = DocumentState.new
    ds.state = "Frumvarp"
    ds.save

    ds = DocumentState.new
    ds.state = "Frumvarp í vinnuhóp"
    ds.save

    ds = DocumentState.new
    ds.state = "Frumvarp í kosningu"
    ds.save

    ds = DocumentState.new
    ds.state = "Samþykkt lög"
    ds.save

  end

  def self.down
  end
end
