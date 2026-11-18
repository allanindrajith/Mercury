import Foundation

// MARK: - WakePhrase tests (pure functions, no concurrency)

@main
enum WakePhraseTests {

    static var failures = 0

    static func main() {
        // MARK: split — should match

        // Basic wake phrases (no command)
        checkMatch("ok mercury",              WakePhrase.split("ok mercury"),              cmd: "")
        checkMatch("OK MERCURY",              WakePhrase.split("OK MERCURY"),              cmd: "")
        checkMatch("okay mercury",            WakePhrase.split("okay mercury"),            cmd: "")
        checkMatch("ok kuku",                WakePhrase.split("ok kuku"),                cmd: "")
        checkMatch("ok cou cou",             WakePhrase.split("ok cou cou"),             cmd: "")
        checkMatch("hey mercury",             WakePhrase.split("hey mercury"),             cmd: "")
        checkMatch("Hey Mercury",             WakePhrase.split("Hey Mercury"),             cmd: "")

        // Command extracted from original text (casing/punctuation preserved)
        checkMatch("Okay, Mercury, ajoute GitHub",
                   WakePhrase.split("Okay, Mercury, ajoute GitHub"),             cmd: "ajoute GitHub")
        checkMatch("ok cuckoo add github",
                   WakePhrase.split("ok cuckoo add github"),                    cmd: "add github")
        checkMatch("ok mercury ouvre figma",
                   WakePhrase.split("ok mercury ouvre figma"),                   cmd: "ouvre figma")

        // Apostrophes, hyphens and accents preserved in command
        checkMatch("OK Mercury, mets l'album de Daft Punk",
                   WakePhrase.split("OK Mercury, mets l'album de Daft Punk"),   cmd: "mets l'album de Daft Punk")
        checkMatch("ok mercury qu'est-ce que fait Claude ?",
                   WakePhrase.split("ok mercury qu'est-ce que fait Claude ?"),  cmd: "qu'est-ce que fait Claude ?")

        // Wake anywhere in transcript (word-boundary search)
        checkMatch("euh ok mercury mets de la musique",
                   WakePhrase.split("euh ok mercury mets de la musique"),        cmd: "mets de la musique")
        checkMatch("la chanson dit ok mercury",
                   WakePhrase.split("la chanson dit ok mercury"),                cmd: "") // accepted false positive

        // LAST occurrence wins
        checkMatch("ok mercury search ok mercury play music",
                   WakePhrase.split("ok mercury search ok mercury play music"),   cmd: "play music")

        // Partial word-by-word delivery
        checkNoMatch("ok alone",             WakePhrase.split("ok"))
        checkMatch("ok mercury partial",      WakePhrase.split("ok mercury"),              cmd: "")
        checkMatch("ok mercury with more",    WakePhrase.split("ok mercury mets"),         cmd: "mets")

        // MARK: split — should NOT match
        checkNoMatch("standalone mercury",    WakePhrase.split("mercury"))
        checkNoMatch("standalone MERCURY",    WakePhrase.split("MERCURY"))
        checkNoMatch("partial mercury ça va", WakePhrase.split("mercury ça va"))
        checkNoMatch("mercury comment",       WakePhrase.split("mercury comment tu vas"))
        checkNoMatch("ok google",            WakePhrase.split("ok google"))
        checkNoMatch("hey siri",             WakePhrase.split("hey siri"))
        checkNoMatch("okkkk mercury",         WakePhrase.split("okkkk mercury"))
        checkNoMatch("empty",                WakePhrase.split(""))

        // Summary
        if failures == 0 { print("\n\(total)/\(total) tests passed.") }
        else { print("\n\(failures) test(s) FAILED."); exit(1) }
    }

    static var total = 0

    static func checkMatch(_ label: String, _ r: WakePhrase.SplitResult, cmd: String) {
        total += 1
        if !r.matched {
            print("✗  \(label) — expected match, got no match"); failures += 1; return
        }
        if r.command != cmd {
            print("✗  \(label) — matched ✓ but command \"\(r.command)\" ≠ \"\(cmd)\""); failures += 1; return
        }
        print("✓  \(label)")
    }

    static func checkNoMatch(_ label: String, _ r: WakePhrase.SplitResult) {
        total += 1
        if r.matched { print("✗  \(label) — expected no match, got matched (cmd: \"\(r.command)\")"); failures += 1 }
        else         { print("✓  \(label)") }
    }
}
