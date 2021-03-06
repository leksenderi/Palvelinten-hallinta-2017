http://terokarvinen.com/2017/aikataulu-%e2%80%93-palvelinten-hallinta-ict4tn022-2-%e2%80%93-5-op-uusi-ops-loppukevat-2017-p2

# Harjoitus 3

* a) Package-File-Server. Asenna ja konfiguroi jokin demoni package-file-server -tyyliin. Tee jokin muu asetus kuin tunnilla näytetty sshd:n portin vaihto.

* b) Modulit Gitistä. Tee skripti, jolla saat nopeasti modulisi kloonattua GitHubista ja ajettua vaikkapa liverompulle. Voit katsoa mallia terokarvinen/nukke GitHub-varastosta.

Harjoitus aloitettiin klo 17:52 (Xubuntu 16.04.01 TryFree)

Aloitetaan pohjustavilla komennoilla

	setxkbmap fi
	sudo apt-get update

	sudo apt-get install -y git
	sudo apt-get install -y puppet

Ennen packagea ja puppettia kun aletaan käyttää, testataan ensiksi kaiken toimivuus pienellä Hello World testillä

	sudo puppet apply -e 'file {"/tmp/moileo": content => "hello\n"}'
	cat /tmp/moileo

Puppet komento teki /tmp/ kansioon "moileo" nimisen tekstitiedoston, missä lukee "hello",
Cat komento tulostaa kyseisen "hello" terminaaliin.

Testataan nyt Puppetin toimivuus tekemällä puppetin modules kansioon "helloleo" niminen kansio, jonne lisätään sisälle vielä manifests kansio, sekä init.pp tiedosto sen sisälle

	cd /etc/puppet/modules
	sudo mkdir helloleo
	cd helloleo
	sudo mkdir manifests
	cd manifests
	sudo nano init.pp

Init.pp tiedoston sisälle laitoin seuraavat konfiguraatiot:

	class helloleo {
        file {"/tmp/hellomodule":
                content => "bla blaa",
        }
	}

Sen jälkeen ajoin puppetilla kyseisen koodin komennolla

	sudo puppet apply -e 'class {helloleo:}'

Nyt löysin /tmp kansiosta "hellomodule" nimisen tiedoston, missä lukee "bla blaa"

Nyt voidaankin siis työstää puppetilla package asennusta. Valitsin Apachen asennettavaksi demoniksi

Tehdään aluksi apachelle oma kansio puppet moduleissa, ja sinne manifests ja templates kansiot

	cd /etc/puppet/modules
	sudo mkdir apache
	cd apache
	sudo mkdir manifests templates

Luodaan manifests kansioon taas init.pp tiedosto. Tällä kertaa sisällöksi laitoin seuraavaa

	class apache {

        exec { 'apt-update':
                command => '/usr/bin/apt-get update'
        }

        package { apache2:
                require => Exec['apt-update'],
                ensure => 'installed',
                allowcdrom => 'true',
        }

        file {'/var/www/html/index.html':
                content => "testing testing",
        }
	}
	
Yllä oleva komento ajaa ensin sudo apt-get updaten, asentaa apachen vasta kun update on ajettu, ja muokkaa apachen vakiosivua luoden sinne "testing testing" tekstin pätkän

Tämän jälkeen ajetaan puppetilla tuo koodinpätkä

	sudo puppet apply -e 'class {apache:}'

Vastauksena tuli

	Notice: Compiled catalog for xubuntu.dhcp.inet.fi in environment production in 0.23 seconds
	Notice: /Stage[main]/Apache/Exec[apt-update]/returns: executed successfully
	Notice: /Stage[main]/Apache/File[/var/www/html/index.html]/content: content changed '{md5}d68ba817e9aa3034436617554da0d2ad' to '{md5}2d5489b9b9d601e49c17274cfbc04077'
	Notice: Finished catalog run in 2.51 seconds

Näyttäisi siis toimivan!

Luodaan vielä skripti, millä saadaan helposti GitHubista tämä luotu moduuli.

	setxkbmap fi
	sudo apt-get update
	sudo apt-get -y install puppet git
	git clone https://github.com/leksenderi/Palvelinten-hallinta-2017.git
	cd /home/xubuntu/Palvelinten-hallinta-2017/Raportit/H3
	bash boot.sh

Kyseinen scripti ajaa päivitykset ja asentaa gitin, kloonaa minun git repositoryn ja avaa H3 harjoituksen kansion.
Testasin vielä skriptin toimivuuden poistamalla git kansioni omasta työpoydästäni, sekä poistin Gitin myös, ja tämän jälkeen ajoin scriptin. Kaikki toimii niin kuin pitääkin, ja repository löytyy omalta työpöydältäni heti.

Harjoitus lopetettiin klo 20:49.
