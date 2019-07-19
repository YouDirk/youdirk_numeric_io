/* This file is part of the `youdirk_numeric_io` Minecraft mod
 * Copyright (C) 2019  Dirk "YouDirk" Lehmann
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */


function insertAfter(newNode, refNode)
{
  refNode.parentNode.insertBefore(newNode, refNode.nextSibling);
}

function init()
{
  var links = document.getElementById("sidebar")
                      .getElementsByClassName("button");
  var a_zip1 = links[0];
  var a_targz2 = links[1];

  a_zip1.innerHTML
    = a_zip1.innerHTML.replace(/(>)[^>]*$/, "$1Mod Stable");
  a_targz2.innerHTML
    = a_targz2.innerHTML.replace(/(>)[^>]*$/, "$1MC Forge");

  var patreon_img = document.createElement("img");
  patreon_img
    .setAttribute("alt", "Become a Patron!");
  patreon_img
    .setAttribute("src", "assets/svg/patreon-popout.200x56.png");

  var patreon_link = document.createElement("a");
  patreon_link
    .setAttribute("href", "https://www.patreon.com/YouDirk");
  patreon_link
    .setAttribute("target", "_blank");
  patreon_link
    .setAttribute("class", "patreon");
  patreon_link.appendChild(patreon_img);
  insertAfter(patreon_link, a_targz2);
}

window.addEventListener('load', init, false);
