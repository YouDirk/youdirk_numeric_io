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


package net.dj_l.youdirk_numeric_io.server;
import net.dj_l.youdirk_numeric_io.common.*;
import net.dj_l.youdirk_numeric_io.*;

// Registries/Events
import net.minecraftforge.registries.IForgeRegistry;
import net.minecraftforge.registries.RegistryBuilder;

// Commands
import com.mojang.brigadier.CommandDispatcher;
import net.minecraft.command.CommandSource;

// Gameplay
import net.minecraft.util.ResourceLocation;

// Non Minecraft/Forge
import javax.annotation.Nullable;


/**
 * A place where all sub-classes of <code>Command</code> are collected
 * for registering these during <code>FMLServerStartingEvent</code>.
 */
public class CommandRegistry
  extends YoudirkNumericIORegistry<CommandBase>
{
  private final ResourceLocation
  _REGISTRY_NAME = new ResourceLocation(Props.MODID, "commands");

  public CommandRegistry()
  {
    super();
    CommandRegistry._INSTANCE = this;

    this.buildRegistry(new RegistryBuilder<CommandBase>()
                       .setType(CommandBase.class)
                       .setName(_REGISTRY_NAME)
                       .disableSaving());
  }

  private static @Nullable CommandRegistry _INSTANCE = null;
  public static @Nullable CommandRegistry get()
  {
    return CommandRegistry._INSTANCE;
  }

  public void registerAll(CommandDispatcher<CommandSource> dispatcher)
  {
    for (CommandBase cmdBase: this.fRegistry) {
      Command<?> cmd = (Command<?>) cmdBase;
      dispatcher.register(cmd.getLiteralForRegister());
    }
  }
}
