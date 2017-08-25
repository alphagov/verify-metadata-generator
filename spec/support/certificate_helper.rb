require 'openssl'
require 'base64'
module CertificateHelper
  def encoded_certificate
    <<-BASE64
MIIDtTCCAp2gAwIBAgIJAI1XoFfAGCetMA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV
BAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQwHhcNMTUwMzI1MTUwODM2WhcNMTUwNDI0MTUwODM2WjBF
MQswCQYDVQQGEwJBVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50
ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAvKItNkNB/0y4RAQq1GEX5OtD8x6sPQ48e1RTlaPkHl4zTgbXUN8Z/W2r
vEpu2ngnmMv7Qe/smVnF5DfsmS0duKJ/FWfc3FuYa8kkjL3VRhfsNM94o4BLKuLA
nzmgfRsa5NTWogavZIAoND8GZfb5sFA/+QFVxlV+7anFIy9893BTfZZ/vu97Itce
7KTf5cnoEmHEy9BCehzWZuCpArHj+qBVsqGbZBPb0migj7APlDuhdUdoQRGuFMV/
Z/Rg7WtxvikcJhzxTuWCpF15zUQnVBEEIesOE2MTlZ+QNUAs2BYAGUTl01NUG95/
O84WAZpdnYXQ5r4fVXiAKUkGe7YbSwIDAQABo4GnMIGkMB0GA1UdDgQWBBTWjGi9
6u7suoq8maN4xeOWlTMviTB1BgNVHSMEbjBsgBTWjGi96u7suoq8maN4xeOWlTMv
iaFJpEcwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClNvbWUtU3RhdGUxITAfBgNV
BAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZIIJAI1XoFfAGCetMAwGA1UdEwQF
MAMBAf8wDQYJKoZIhvcNAQEFBQADggEBAFM3WeyLseUUrH5ifTuNQE7+sNSwWs95
lOryvcBWHy2pCjOHviuE0sNMMfLNyfzHzrBoY6zhhsRwcr7LvmWAofzNgMT9pr2I
s14dwurDHmVIjVdwaWWQv2/Pt1apor0SuJcNTAS8dp2aQp+iz/bVtQ0oktfJkGAB
vSWsH7aBbWbR5/sPZhbRXHrbV92rHm6j0MpmrMh9lcfbhQLlXqnPwNPHZLxlX9+b
rKem2BKTFp95nU39JmrB4wkV4BSXIc5nbm2nNxBgSAg13P8trWFn+HNkyeS74GdG
Gy7g33oOiu0iYqP9AxMUhZtgeOGsyYFa/LRiHJGdciK4+bya21zrygk=
    BASE64
  end

  def encoded_certificate_2
    <<-BASE64
MIIDtTCCAp2gAwIBAgIJAI1XoFfAGCetMA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV
BAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQwHhcNMTUwMzI1MTUwODM2WhcNMTUwNDI0MTUwODM2WjBF
MQswCQYDVQQGEwJBVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50
ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAvKItNkNB/0y4RAQq1GEX5OtD8x6sPQ48e1RTlaPkHl4zTgbXUN8Z/W2r
vEpu2ngnmMv7Qe/smVnF5DfsmS0duKJ/FWfc3FuYa8kkjL3VRhfsNM94o4BLKuLA
nzmgfRsa5NTWogavZIAoND8GZfb5sFA/+QFVxlV+7anFIy9893BTfZZ/vu97Itce
7KTf5cnoEmHEy9BCehzWZuCpArHj+qBVsqGbZBPb0migj7APlDuhdUdoQRGuFMV/
Z/Rg7WtxvikcJhzxTuWCpF15zUQnVBEEIesOE2MTlZ+QNUAs2BYAGUTl01NUG95/
O84WAZpdnYXQ5r4fVXiAKUkGe7YbSwIDAQABo4GnMIGkMB0GA1UdDgQWBBTWjGi9
6u7suoq8maN4xeOWlTMviTB1BgNVHSMEbjBsgBTWjGi96u7suoq8maN4xeOWlTMv
iaFJpEcwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClNvbWUtU3RhdGUxITAfBgNV
BAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZIIJAI1XoFfAGCetMAwGA1UdEwQF
MAMBAf8wDQYJKoZIhvcNAQEFBQADggEBAFM3WeyLseUUrH5ifTuNQE7+sNSwWs95
lOryvcBWHy2pCjOHviuE0sNMMfLNyfzHzrBoY6zhhsRwcr7LvmWAofzNgMT9pr2I
s14dwurDHmVIjVdwaWWQv2/Pt1apor0SuJcNTAS8dp2aQp+iz/bVtQ0oktfJkGAB
vSWsH7aBbWbR5/sPZhbRXHrbV92rHm6j0MpmrMh9lcfbhQLlXqnPwNPHZLxlX9+b
rKem2BKTFp95nU39JmrB4wkV4BSXIc5nbm2nNxBgSAg13P8trWFn+HNkyeS74GdG
Gy7g33oOiu0iYqP9AxMUhZtgeOGsyYFa/LRiHJGdciK4+bya21zrdje=
    BASE64
  end

  PKI_PATH = File.expand_path("../files/certs", __FILE__)


  def root_certificate_string
    File.read(File.join(PKI_PATH, "ca.cert.pem"))
  end

  def root_certificate
    OpenSSL::X509::Certificate.new(root_certificate_string)
  end

  def intermediate_certificate_string
    File.read(File.join(PKI_PATH, "intermediate.cert.pem"))
  end

  def intermediate_certificate
    OpenSSL::X509::Certificate.new(intermediate_certificate_string)
  end

  def certificate_a_string
    File.read(File.join(PKI_PATH, "metadata-signing-a.cert.pem"))
  end

  def certificate_a
    OpenSSL::X509::Certificate.new(certificate_a_string)
  end

  def certificate_a_inline_string
    Base64.encode64(certificate_a.to_der)
  end

  class PKI
    def initialize(cn = "TEST CA")
      @root_ca = generate_root_certificate(cn)
    end

    def generate_root_certificate(cn)
      @root_key = OpenSSL::PKey::RSA.new 2048 # the CA's public/private key
      root_ca = OpenSSL::X509::Certificate.new
      root_ca.version = 2 # cf. RFC 5280 - to make it a "v3" certificate
      root_ca.serial = 1
      root_ca.subject = OpenSSL::X509::Name.parse "/DC=org/DC=TEST/CN=#{cn}"
      root_ca.issuer = root_ca.subject # root CA's are "self-signed"
      root_ca.public_key = @root_key.public_key
      root_ca.not_before = Time.now
      root_ca.not_after = root_ca.not_before + 2 * 365 * 24 * 60 * 60 # 2 years validity
      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = root_ca
      ef.issuer_certificate = root_ca
      root_ca.add_extension(ef.create_extension("basicConstraints","CA:TRUE",true))
      root_ca.add_extension(ef.create_extension("keyUsage","keyCertSign, cRLSign", true))
      root_ca.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
      root_ca.add_extension(ef.create_extension("authorityKeyIdentifier","keyid:always",false))
      root_ca.sign(@root_key, OpenSSL::Digest::SHA256.new)
    end

    attr_reader :root_ca

    def sign(cert)
      cert.not_before = Time.now
      cert.not_after = cert.not_before + 1 * 365 * 24 * 60 * 60 # 1 years validity
      cert.issuer = @root_ca.subject # root CA is the issuer
      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = cert
      ef.issuer_certificate = root_ca
      cert.add_extension(ef.create_extension("keyUsage","digitalSignature", true))
      cert.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
      cert.sign(@root_key, OpenSSL::Digest::SHA256.new)
    end
  end
    
  def generate_cert(cn = "GENERATED TEST CERTIFICATE")
    key = OpenSSL::PKey::RSA.new 2048
    cert = OpenSSL::X509::Certificate.new
    cert.version = 2
    cert.serial = 2
    cert.subject = OpenSSL::X509::Name.parse "/DC=org/DC=TEST/CN=#{cn}"
    cert.public_key = key.public_key
    cert
  end

  def test_pki
    @test_pki ||= PKI.new
  end

  def hub_pki
    @hub_pki ||= PKI.new
  end

  def idp_pki
    @idp_pki ||= PKI.new
  end
end
