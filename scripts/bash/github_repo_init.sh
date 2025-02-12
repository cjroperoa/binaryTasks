# Copyright 2025 Cristian Ropero
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash -e

# Validate instalation jq
if ! command -v jq &> /dev/null; then
  echo "🔴 Error: jq no está instalado."

  read -p "¿Deseas instalar jq? (Y/N): " install_choice
  if [[ "$install_choice" =~ ^[Yy]$ ]]; then
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      echo "🛠 Instalando jq en Linux..."
      sudo apt-get update && sudo apt-get install -y jq
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      echo "🛠 Instalando jq en macOS..."
      brew install jq
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
      echo "🛠 Instalando jq en Windows (usando winget)..."
      if ! command -v winget &> /dev/null; then
        echo "🔴 Error: winget no está instalado en tu sistema."
        exit 1
      fi
      winget install jqlang.jq
    else
      echo "🔴 OS no soportado para instalación automática de jq."
      exit 1
    fi

    if command -v jq &> /dev/null; then
      echo "🟢 jq se ha instalado correctamente."
    else
      echo "🔴 Error: No se pudo instalar jq."
      exit 1
    fi
  else
    echo "🔴 Se requiere jq. Finaliza ejecución."
    exit 1
  fi
fi

# ENV
attempts=0
max_attempts=3
projects_dir="D:/Projects"
copyright_year=$(date +'%Y')

create_readme_file() {
  local project_name="$1"
  local project_description="$2"
  local project_license="$3"
  local author_name="$4"
  local project_path="$5"
  
  if [[ -z "$project_name" || -z "$project_description" || -z "$project_license" || -z "$author_name" ]]; then
    echo "🔴 Error creando README.md Faltan parámetros."
    return 1
  fi

  cat <<EOF > "$project_path/README.md"
# $project_name

## Descripción
$project_description

## Licencia
Proyecto bajo la Licencia $project_license. Consulta el archivo LICENSE para más detalles.

## Autor
$author_name
EOF
  echo " 🟢 Archivo README.md creado con éxito  <- $project_path/README.md"
}

create_license_file() {
  local license_type="$1"
  local copyright_year="$2"
  local copyright_author="$3"
  local project_path="$4"

  if [[ -z "$license_type" || -z "$copyright_year" || -z "$copyright_author" || -z "$project_path" ]]; then
    echo "❌ Faltan parámetros. Asegúrese de proporcionar el tipo de licencia, año de copyright y nombre de copyright."
    return 1
  fi

  local license_text=""
  
  case "$license_type" in
    "MIT License")
      license_text=$(cat <<EOF
MIT License

Copyright (c) $copyright_year $copyright_author

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
      )
      ;;
    "Apache License 2.0")
      license_text=$(cat <<EOF

                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "[]"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright $copyright_year $copyright_author

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
EOF
      )
      ;;
    "GPL-3.0 License")
      license_text=$(cat <<EOF
    GNU GENERAL PUBLIC LICENSE
    Version 3, 29 june 2007

    Copyright (C) $copyright_year $copyright_name

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
EOF
      )
      ;;
    *)
      echo "❌ Licencia desconocida: $license_type. No se genera el archivo LICENSE."
      return 1
      ;;
  esac
  
  echo "$license_text" >"$project_path/LICENSE"
  echo " 🟢 Archivo LICENSE creado con éxito  <-  $project_path/LICENSE"
}

validate_camel() {
  [[ "$1" =~ ^[a-z]+([A-Z][a-z0-9]*)*$ ]] && return 0 || return 1
}

validate_snake() {
  [[ "$1" =~ ^[a-z]+(_[a-z0-9]+)*$ ]] && return 0 || return 1
}

validate_kebab() {
  [[ "$1" =~ ^[a-z]+(-[a-z0-9]+)*$ ]] && return 0 || return 1
}

validate_pascal() {
  [[ "$1" =~ ^[A-Z][a-z]+([A-Z][a-z0-9]*)*$ ]] && return 0 || return 1
}

convert_to_readable() {
  local project_name="$1"
  
  readable=$(echo "$project_name" | sed -r 's/([a-z])([A-Z])/\1 \2/g' | sed 's/[-_]/ /g' | sed 's/\b\(.\)/\u\1/g')
  
  echo $readable
}

# 0. Dir root
echo "🗃️ Directorio de trabajo configurado:"

if [ -d "$projects_dir" ]; then
  echo " 🟢 $projects_dir   <- operativo"
  echo
  read -p "Cambiar directorio (Y/N)❔: " change_choice
  if [[ "$change_choice" =~ ^[Yy]$ ]]; then
    read -p "Ruta del nuevo directorio raíz de proyectos: " projects_dir
    echo " 🟢 Directorio raíz configurado: $projects_dir"
  else
    echo " 🟢 Directorio de trabajo  ->  $projects_dir"
  fi
else
  echo "  🔴 $projects_dir   <- no operativo."
  read -p "Ruta del nuevo directorio raíz de proyectos: " projects_dir
  echo " 🟢 Directorio de trabajo configurado  ->  $projects_dir"
fi

# 1. Project Notation
echo
echo " 1. camelCase"
echo " 2. snake_case"
echo " 3. kebab-case"
echo " 4. PascalCase"
read -p "Notación directorio proyecto: " notation_choice

case "$notation_choice" in
1) notation_name_project="camel" ;;
2) notation_name_project="snake" ;;
3) notation_name_project="kebab" ;;
4) notation_name_project="pascal" ;;
*)
  echo "⚠️ Opción no válida. Finalizando script."
  exit 1
  ;;
esac
echo " 🟢 Notación $project_path: $notation_name_project"

# 2. Project Name
while [ $attempts -lt $max_attempts ]; do
  echo
  read -p "Nombre del proyecto ($notation_name_project): " project_name
  case "$notation_name_project" in
  "camel")
    if validate_camel "$project_name"; then
      echo " 🟢 Válido para camelCase: $project_name"
      break
    else
      ((attempts++))
      echo " 🔴 Error: El nombre debe estar en formato camelCase."
    fi
    ;;
  "snake")
    if validate_snake "$project_name"; then
      echo " 🟢 Válido para snake_case: $project_name"
      break
    else
      ((attempts++))
      echo " 🔴 Error: El nombre debe estar en formato snake_case."
    fi
    ;;
  "kebab")
    if validate_kebab "$project_name"; then
      echo "🟢 Válido para kebab-case: $project_name"
      break
    else
      ((attempts++))
      echo " 🔴 Error: El nombre debe estar en formato kebab-case."
    fi
    ;;
  "pascal")
    if validate_pascal "$project_name"; then
      echo " 🟢 Válido para PascalCase: $project_name"
      break
    else
      ((attempts++))
      echo " 🔴 Error: El nombre debe estar en formato PascalCase."
    fi
    ;;
  esac

  echo "⚠️ Tienes [ $((max_attempts - attempts)) ] intentos restantes."
done

if [ $attempts -ge $max_attempts ]; then
  echo "🚫 Has alcanzado el máximo de intentos $max_attempts. La ejecución finaliza."
  exit 1
fi

# 3. Project directory local
project_path="$projects_dir/$project_name"
if [ ! -d "$project_path" ]; then
  mkdir "$project_path"
  echo " 🟢 $project_path  <- directorio creado"
else
  echo " 🟡 $project_path  <- ya existente, verificar!! $project_path"
  exit
fi
# Unix permissions
if [[ "$OSTYPE" != "msys" && "$OSTYPE" != "cygwin" ]]; then
  chmod 775 "$project_path"
  echo " 🟢 Permisos unix ajustados."
fi

# 4. Visibility repository
echo
echo " 1. Private"
echo " 2. Public"
read -p "Visibilidad del repositorio: " visibility_choice

if [ "$visibility_choice" -eq 1 ]; then
  visibility="true"  # Private
  visibility_type="Private"
elif [ "$visibility_choice" -eq 2 ]; then
  visibility="false"  # Public
  visibility_type="Public"
else
  visibility="true"  # Default
  visibility_type="Private (default)"
fi

echo " 🟢 Repo $project_name: $visibility_type"


# 5. License repository
echo
echo " 1. MIT License"
echo " 2. Apache License 2.0"
echo " 3. GPL-3.0 License"
echo " 0. None"
read -p "Licencia del repositorio: " license_choice
case $license_choice in
1) license_type="MIT License" ;;
2) license_type="Apache License 2.0" ;;
3) license_type="GPL-3.0 License" ;;
*) license_type="none" ;;
esac
echo " 🟢 Licensia repo $project_name: $license_type"

# 6. Personal Access Token GitHub
echo 
echo "⏳ Cargando variable entorno del sistema GITHUB_TOKEN"
github_token=$GITHUB_TOKEN
if [ -z "$github_token" ]; then
  echo " ⚠️ Variable de entorno GITHUB_TOKEN no encontrada. Buscando en archivo .env..."

  if [ -f ".env" ]; then
    source .env
    if [ -z "$GITHUB_TOKEN" ]; then
      echo " ⚠️ El archivo .env no contiene la variable GITHUB_TOKEN."
    else
      github_token=$GITHUB_TOKEN
    fi
  else
    echo " 🔴 No se encontró el archivo .env"
  fi
fi

if [ -z "$github_token" ]; then
  echo " 🔴 Aún no se ha configurado el token de acceso de GitHub."
  echo " 🔑 Puedes generar un token en: https://github.com/settings/tokens"
  read -p "🔐 Ingrese el token de acceso de GitHub: " github_token
fi

token_valid=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $github_token" https://api.github.com/user)

if [ "$token_valid" != "200" ]; then
  echo " 🔴 Token inválido. Verifica y vuelve a intentarlo."
  exit 1
else
  github_user=$(curl -s -H "Authorization: token $github_token" https://api.github.com/user | jq -r .login)
  # Copyright author
  github_name_profile=$(curl -s -H "Authorization: token $github_token" https://api.github.com/user | jq -r .name)
  echo " 🟢 Token Válido 🤖 Usuario: $github_user"
fi

# 7. GitHub Repository
echo
echo "⏳ Creando repositorio en GitHub..."
api_url="https://api.github.com/user/repos"
json_data=$(
  cat <<EOF
{
  "name": "$project_name",
  "private": $visibility,
  "has_issues": true,
  "has_projects": true,
  "has_wiki": true
}
EOF
)
response=$(curl -s -X POST -H "Authorization: token $github_token" -d "$json_data" "$api_url") || { echo "🔴 Error en la solicitud HTTP"; exit 1; }
if echo "$response" | grep -q "\"name\": \"$project_name\""; then
  echo " 🟢 Repositorio en GitHub '$project_name' creado correctamente."
else
  echo " 🔴 Error creando repositorio en Github. ⚠️ $response"
  exit 1
fi

# 8. README.md & LICENSE
echo
echo "⏳ Creando README.md & LICENSE"
readable_name=$(convert_to_readable "$project_name")
description="Repositorio del proyecto $readable_name con la configuración básica de inicio"

if [[ "$license_type" == "none" ]]; then
  echo " 🟡 Creando un archivo LICENSE vacío."
  touch "$project_path/LICENSE"
  echo " 🟢 Archivo LICENSE vacío creado en $project_path/"
else
  create_license_file "$license_type" "$copyright_year" "$github_name_profile" "$project_path"
fi

create_readme_file "$readable_name" "$description" "$license_type" "$github_name_profile" "$project_path"


# 9. Add repo remote
echo
echo "⏳ Enlazando repositorio local a GitHub..."
cd "$project_path" || { echo " 🔴 Error: No se pudo acceder al directorio $project_path"; exit 1; }
git init || { echo " 🔴 Error: No se pudo inicializar el repositorio Git."; exit 1; }
git add README.md LICENSE || { echo " 🔴 Error: No se pudo agregar los archivos al repositorio."; exit 1; }
git commit -m "chore: 🎉 init" || { echo " 🔴 Error: No se pudo hacer el commit."; exit 1; }
git branch -M main || { echo " 🔴 Error: No se pudo cambiar la rama a main."; exit 1; }
git remote add origin "https://github.com/$github_user/$project_name.git" || { echo "🔴 Error: No se pudo agregar el repositorio remoto."; exit 1; }
echo " 🟢 Repositorio enlazado exitosamente con GitHub."

# 10. Push repo
echo
echo "⏳ Haciendo push a repositorio remoto GitHub..."
push_output=$(git push -u origin main 2>&1)

if echo "$push_output" | grep -q "fatal"; then
  echo " 🔴 Error al realizar el Push a GitHub."
  echo "Detalles del error: $push_output"  
  if echo "$push_output" | grep -q "Permission denied"; then
    echo " ⚠️ Parece que hay un problema de permisos. Asegúrate de que tu token de acceso sea válido y que tienes permisos para escribir en el repositorio."
  elif echo "$push_output" | grep -q "fatal: could not read from remote repository"; then
    echo " ⚠️ No se pudo leer desde el repositorio remoto. Verifica tu conexión a internet y que el repositorio exista."
  elif echo "$push_output" | grep -q "fatal: refusing to merge unrelated histories"; then
    echo " ⚠️ Hay un conflicto de historia. Puede que el repositorio remoto tenga un historial diferente al tuyo. Intenta hacer un 'git pull' primero."
  else
    echo " ⚠️ Error desconocido. Revisar detalles proporcionados y ajustar la configuración."
  fi
  exit 1
else
  echo " 🟢  Push Ok - Good Luck  🎉"
fi

# 11. Summary
summary_file="$project_path/summary.txt"
echo
echo "📝 Generando resumen en $summary_file"
echo "" > "$summary_file"
echo "Resumen de la creación del repositorio" >> "$summary_file"
echo "=====================================" >> "$summary_file"
echo "Nombre del Proyecto: $project_name" >> "$summary_file"
echo "Fecha de creación: $(date)" >> "$summary_file"
echo "Notación dir. raiz: $notation_name_project case" >> "$summary_file"
echo "Ruta del Proyecto: $project_path" >> "$summary_file"
echo "Visibilidad del repositorio: $visibility_type" >> "$summary_file"
echo "" >> "$summary_file"
echo "Licencia del repositorio: $license_type" >> "$summary_file"
echo "" >> "$summary_file"
echo "README.md y LICENSE creados en el proyecto" >> "$summary_file"
echo "Archivo LICENSE: $project_path/LICENSE" >> "$summary_file"
echo "Archivo README.md: $project_path/README.md" >> "$summary_file"
echo "" >> "$summary_file"
echo "Repositorio en GitHub creado con éxito: $project_name" >> "$summary_file"
echo "Push realizado con éxito al repositorio de GitHub." >> "$summary_file"
echo "" >> "$summary_file"
echo "Proceso completado con éxito." >> "$summary_file"
echo " 🟢 Resumen completo generado en $summary_file"