// Benutzer und Gruppen des Uebungs-Linux. Daraus entstehen auch /etc/passwd
// und /etc/group im Grund-Dateisystem.

export type Benutzer = { name: string; uid: number; home: string; shell: string; beschreibung: string };
export type Gruppe = { name: string; gid: number; mitglieder: string[] };

export const BENUTZER: Benutzer[] = [
  { name: "root", uid: 0, home: "/root", shell: "/bin/bash", beschreibung: "root" },
  { name: "www-data", uid: 33, home: "/var/www", shell: "/usr/sbin/nologin", beschreibung: "www-data" },
  // Schreibt unter Ubuntu die Protokolle in /var/log (rsyslog)
  { name: "syslog", uid: 102, home: "/nonexistent", shell: "/usr/sbin/nologin", beschreibung: "" },
  { name: "azubi", uid: 1000, home: "/home/azubi", shell: "/bin/bash", beschreibung: "Azubi" },
  { name: "mia", uid: 1001, home: "/home/mia", shell: "/bin/bash", beschreibung: "Mia" },
];

export const GRUPPEN: Gruppe[] = [
  { name: "root", gid: 0, mitglieder: [] },
  { name: "adm", gid: 4, mitglieder: ["syslog", "azubi"] },
  { name: "sudo", gid: 27, mitglieder: ["azubi"] },
  { name: "shadow", gid: 42, mitglieder: [] },
  { name: "www-data", gid: 33, mitglieder: [] },
  { name: "syslog", gid: 102, mitglieder: [] },
  { name: "azubi", gid: 1000, mitglieder: [] },
  { name: "mia", gid: 1001, mitglieder: [] },
];

export function benutzer(name: string): Benutzer | undefined {
  return BENUTZER.find((b) => b.name === name);
}

export function gruppe(name: string): Gruppe | undefined {
  return GRUPPEN.find((g) => g.name === name);
}

/** Home-Ordner eines Benutzers, Standard /home/<name>. */
export function homeVon(name: string): string {
  return benutzer(name)?.home ?? `/home/${name}`;
}

/** Hauptgruppe (gleichnamig) plus alle Gruppen, in denen der Benutzer Mitglied ist. */
export function gruppenVon(name: string): string[] {
  const liste = GRUPPEN.filter((g) => g.name === name || g.mitglieder.includes(name)).map((g) => g.name);
  return liste.length > 0 ? liste : [name];
}

export function passwdText(): string {
  return (
    BENUTZER.map((b) => {
      const gid = gruppe(b.name)?.gid ?? b.uid;
      return `${b.name}:x:${b.uid}:${gid}:${b.beschreibung}:${b.home}:${b.shell}`;
    }).join("\n") + "\n"
  );
}

export function groupText(): string {
  return GRUPPEN.map((g) => `${g.name}:x:${g.gid}:${g.mitglieder.join(",")}`).join("\n") + "\n";
}
