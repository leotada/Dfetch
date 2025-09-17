module logos;

@safe:

// Minimal ASCII logos (kept compact). Extend as needed.
// getLogoForDistro:
//  Recebe o ID canônico da distribuição (detectOSID) e retorna um ASCII logo compacto.
//  Para adicionar suporte a novas distros:
//    1. Identifique o valor de ID em /etc/os-release (ex: "opensuse", "alpine").
//    2. Adicione um novo case no switch abaixo retornando um bloco q"EOS ... EOS".
//    3. Mantenha largura e altura razoáveis para alinhar com a área de texto (<= ~12 linhas).
//  Fallback: um logo genérico se o ID não for reconhecido.
string getLogoForDistro(string id)
{
    switch(id)
    {
        case "arch":
            return q"EOS
                   -`
                  .o+`
                 `ooo/
                `+oooo:
               `+oooooo:
               -+oooooo+:
             `/:-:++oooo+:
            `/++++/+++++++:
           `/++++++++++++++:
          `/+++ooooooooooooo/`
         ./ooosssso++osssssso+`
        .oossssso-````/ossssss+`
       -osssssso.      :ssssssso.
      :osssssss/        osssso+++.
     /ossssssss/        +ssssooo/-
   `/ossssso+/:-        -:/+osssso+-
  `+sso+:-`                 `.-/+oso:
 `++:.                           `-/+/
 .`                                 `/
EOS";
        case "ubuntu":
            return q"EOS
            .-/+oossssoo+/-.
        `:+ssssssssssssssssss+:`
      -+ssssssssssssssssssyyssss+-
    .ossssssssssssssssssdMMMNysssso.
   /ssssssssssshdmmNNmmyNMMMMhssssss/
  +ssssssssssshMMMMMMMMNNNmmmdsssssss+
 /ssssssssssshMMMMMMMMMMMMMmmhssssssss/
+sssssssssssNMMMMMMMMMMMMMMMMmsssssssss+
+sssssssssssNMMMMMMMMMMMMMMMMmsssssssss+
/ssssssssssshMMMMMMMMMMMMMmmhssssssss/
 +ssssssssssshMMMMMMMMNNNmmmdsssssss+
  /ssssssssssshdmmNNmmyNMMMMhssssss/
   .ossssssssssssssssssdMMMNysssso.
     -+ssssssssssssssssssyyssss+-
       `:+ssssssssssssssssss+:`
           .-/+oossssoo+/-.
EOS";
        case "debian":
            return q"EOS
            ./+o+-
         `..-`   `..-`
      `..-`         `..-`
   `..-`               `..-`
`..-`                     `..-`
-`                           `-
.`                           `.
.`                           `.
.`                           `.
.`                           `.
-`                           `-
`..-`                     `..-`
   `..-`               `..-`
      `..-`         `..-`
         `..-`   `..-`
            ./+o+-
EOS";
        case "fedora":
            return q"EOS
             .',;::::;,'.
         .';:cccccccccccc:;,.
      .;cccccccccccccccccccccc;.
    .:cccccccccccccccccccccccccc:.
  .;ccccccccccccc;.:dddl:.;ccccccc;.
 .:ccccccccccccc;OWMKOOXMWd;ccccccc:.
.:ccccccccccccc;KMMc;cc;xMMc;ccccccc:.
,cccccccccccccc;MMM.;cc;;WW:;cccccccc,
:cccccccccccccc;MMM.;cccccccccccccccc:
:ccccccc;oxOOOo;MMM000k.;cccccccccccc:
cccccc;0MMKxdd:;MMMkddc.;cccccccccccc;
ccccc;XMO';cccc;MMM.;cccccccccccccccc'
ccccc;MMo;ccccc;MMW.;ccccccccccccccc;
ccccc;0MNc.ccc.xMMd;ccccccccccccccc;
cccccc;dNMWXXXWM0:;cccccccccccccc:,
cccccccc;.:odl:.;cccccccccccccc:,.
ccccccccccccccccccccccccccccc:'.
:ccccccccccccccccccccccc:;,..
 ':cccccccccccccccc::;,.
EOS";
        case "manjaro":
            return q"EOS
████████████████████████
████████████████████████
████████████████████████
████████████████████████
████████████████████████
████████████████████████
EOS";
        default:
            return q"EOS
             .',;::::;,'.
         .';:cccccccccccc:;,.
      .;cccccccccccccccccccccc;.
    .:cccccccccccccccccccccccccc:.
  .;ccccccccccccc;.:dddl:.;ccccccc;.
 .:ccccccccccccc; generic ;ccccccc:.
.:ccccccccccccc;  linux   ;ccccccc:.
EOS"; // trimmed generic fallback
    }
}